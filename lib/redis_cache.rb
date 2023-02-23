module RedisCache

  CACHE_KEY_GLOBAL_COUNTER = "global_counter"

  class << self

    def hset(key, hkey, hvalue, expire_at=nil)
      raise "hvalue must be string." if !hvalue.is_a?(String)
      $redis.hset(key, hkey, hvalue)
      $redis.expire(key, expire_at) if expire_at
    end

    def hfetch(key, hkey, expire_at=nil)
      cache_result = $redis.hget(key, hkey)
      if cache_result.nil? && block_given?
        cache_result = yield(self)
        if !cache_result.nil?
          $redis.hset(key, hkey, cache_result)
          $redis.expire(key, expire_at) if expire_at
        end
      end
      cache_result
    end

    def hdel(key, hkey)
      $redis.hdel(key, hkey)
    end

    def hset_list(key, hkey, hvalue, expire_at=nil)
      raise "hvalue must be array." if !hvalue.is_a?(Array)
      $redis.hset(key, hkey, hvalue.join("|||"))
      $redis.expire(key, expire_at) if expire_at
    end

    def hfetch_list(key, hkey, expire_at=nil)
      cache_result = $redis.hget(key, hkey)
      if cache_result.nil? && block_given?
        cache_result = yield(self)
        if !cache_result.nil?
          raise ("block result must be array") if !cache_result.is_a?(Array)
          $redis.hset(key, hkey, cache_result.join("|||"))
          $redis.expire(key, expire_at) if expire_at
        end
      end
      cache_result.is_a?(String) ? cache_result.split("|||") : cache_result
    end

    def hset_bool(key, hkey, hvalue, expire_at=nil)
      raise "hvalue must be boolean." if !(!!hvalue == hvalue)
      cache_value = hvalue ? '1' : '0'
      $redis.hset(key, hkey, cache_value)
      $redis.expire(key, expire_at) if expire_at
    end

    def hfetch_bool(key, hkey, expire_at=nil)
      raise "must have block." if !block_given?
      cache_result = $redis.hget(key, hkey)
      if cache_result.nil?
        cache_result = yield(self)
        cache_value = cache_result ? '1' : '0'
        $redis.hset(key, hkey, cache_value)
        $redis.expire(key, expire_at) if expire_at
      else
        cache_result = cache_result == '1' ? true : false
      end
      cache_result
    end

    def hset_json(key, hkey, hvalue, expire_at=nil)
      $redis.hset(key, hkey, hvalue) if !hvalue.nil?
      $redis.expire(key, expire_at) if expire_at
    end

    def hget_json(key, hkey)
      result = $redis.hget(key, hkey)
      result.nil? ? nil : JSON.parse(result, symbolize_names: true)
    end

    def hfetch_json(key, hkey, expire_at=nil)
      cache_result = $redis.hget(key, hkey)
      if cache_result.nil? && block_given?
        cache_result = yield(self).to_a.map { |r| r.attributes.symbolize_keys }
        $redis.hset(key, hkey, cache_result.to_json) if !cache_result.nil?
      else
        cache_result = JSON.parse(cache_result, symbolize_names: true)
      end
      cache_result
    end

    # 检测是否是频繁的访问(1秒钟内多次)
    def is_concurrent?(flag,wait=5)
      # 使用redis加锁，避免ios并发重复请求，并且在5秒钟之后过期
      lock_key = "#{flag}_#{Time.now.to_i}"
      lock_result = $redis.multi do
        $redis.setnx(lock_key, Time.now.to_i)
        $redis.expire(lock_key, wait)
      end
      !lock_result.first
    end

    # 检测是否是频繁的访问(n秒钟内多次)
    def wait_concurrent?(lock_key, wait=60, count=5)
      # 使用redis加锁，避免ios并发重复请求
      request_count = $redis.get(lock_key).to_i
      if request_count.present? && request_count >= count
        true
      else
        # set_key_with_lock(lock_key, wait)
        request_count += 1
        $redis.setex(lock_key, wait, request_count)
        false
      end
    end

    # redis线程安全的处理
    def set_key_with_lock(key, expire_at)
      set_lock_time = (Time.now + 5.seconds).to_i
      lock = $redis.setnx("lockkey", set_lock_time)
      # 获得锁，直接执行逻辑代码  
      if lock
        count = $redis.get(key).to_i
        $redis.setex(key, expire_at, count+1)
        if set_lock_time > Time.now.to_i
          # 释放锁
          $redis.del("lockkey")
        end
      else
        old_lock_time = $redis.get("lockkey")
        # 当前时间大于锁的时间，表示锁已经超时
        if old_lock_time.blank? || Time.now.to_i > old_lock_time.to_i
          last_lock_time = $redis.getset("lockkey", set_lock_time)
          # 使用getset去获取上一次的锁过期时间，如果等于old_lock_time，表示锁没有被其他线程请求走
          if last_lock_time == old_lock_time
            count = $redis.get(key).to_i
            $redis.setex(key, expire_at, count+1)
            # 处理完该线程逻辑后，如果设置的锁占用时间大于当前时间，则释放该锁
            if set_lock_time > Time.now.to_i
              # 释放锁
              $redis.del("lockkey")
            end
          else
            set_key_with_lock(key, expire_at)
          end
        else
          set_key_with_lock(key, expire_at)
        end
      end
    end

    def match_redis_key(match, next_cursor=-1, keys=[], loop_times=0)
      return [keys,next_cursor] if next_cursor == 0 || loop_times == 50
      cursor = next_cursor == -1 ? 0 : next_cursor
      result = $redis.scan(cursor, match: match)
      next_cursor = result.first.to_i
      match_keys = result.last
      if next_cursor == 0
        return [keys | match_keys, next_cursor]
      else
        match_redis_key(match, next_cursor, match_keys|keys, loop_times+1)
      end
    end
  end
end
