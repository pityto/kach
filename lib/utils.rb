module Utils

  GB = 1000 * 1000 * 1000
  IP_RANGE = {
    "0": [IPAddr.new("0.0.0.0/8")],
    "10": [IPAddr.new("10.0.0.0/8")],
    "100": [IPAddr.new("100.64.0.0/10")],
    "127": [IPAddr.new("127.0.0.0/8")],
    "169": [IPAddr.new("169.254.0.0/16")],
    "172": [IPAddr.new("172.16.0.0/12")],
    "192": [IPAddr.new("192.0.0.0/24"), IPAddr.new("192.0.0.0/29"),
            IPAddr.new("192.0.0.8/32"), IPAddr.new("192.0.0.9/32"),
            IPAddr.new("192.0.0.10/32"), IPAddr.new("192.0.0.170/32"),
            IPAddr.new("192.0.0.171/32"), IPAddr.new("192.0.2.0/24"),
            IPAddr.new("192.31.196.0/24"), IPAddr.new("192.52.193.0/24"),
            IPAddr.new("192.88.99.0/24"), IPAddr.new("192.168.0.0/16"),
            IPAddr.new("192.175.48.0/24")
            ],
    "198": [IPAddr.new("198.18.0.0/15"), IPAddr.new("198.51.100.0/24")],
    "203": [IPAddr.new("203.0.113.0/24")],
    "240": [IPAddr.new("240.0.0.0/4")]
  }


  def self.split_id(id)
    AesEncrypt.encrypt(id,"attchment_key").delete("/")
  end

  def self.check_cas(cas)
    cas = cas.to_s.strip.gsub(/[^\d\-]+/,'')
    return false if cas.blank?
    seg = cas.to_s.split('-')
    return false if seg.size != 3
    return false if seg[1].size != 2
    return false if seg[2].size != 1

    nums = "#{seg[0]}#{seg[1]}".reverse.split(//)
    sum = 0
    nums.each_with_index do |n,idx|
      sum += n.to_i * (idx + 1)
    end

    sum % 10 == seg[2].to_i ? cas : false
  end

  # Symmetric-key algorithm
  class AesEncrypt
    def self.encrypt(string, key)
      #cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      #cipher.encrypt
      #cipher.key = key
      #cipher.iv = '3jdrjf3iodsf3290'
      #encrypted = cipher.update(string) + cipher.final
      #Base64.urlsafe_encode64(encrypted)
      ::AesCrypt.encrypt(string, key).strip
    end

    def self.decrypt(string, key)
      #base64_decoded = Base64.urlsafe_decode64(string)
      #cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      #cipher.decrypt
      #cipher.key = key
      #cipher.iv = '3jdrjf3iodsf3290'
      #cipher.update(base64_decoded) + cipher.final
      ::AesCrypt.decrypt(string, key)
    end
  end

  module Gen

    def self.serial_number
      now = Time.now
      rand_num = (SecureRandom.random_number * 10000).to_i
      hex = SecureRandom.hex(2)
      %(#{now.strftime("%Y%m%d")}#{now.to_i}#{rand_num}#{hex})
    end

    def self.friendly_token(length = 20)
      # To calculate real characters, we must perform this operation.
      # See SecureRandom.urlsafe_base64
      rlength = (length * 3) / 4
      SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
    end

    def self.friendly_code(length = 8)
      rlength = (length * 3) / 4
      SecureRandom.urlsafe_base64(rlength).downcase.tr('l1o0_-', 'qrsxyz')
    end

    def self.generate_uuid
      UUIDTools::UUID.timestamp_create.to_s
    end
  end

  module IP
    def self.valid?(addr)
      valid_ipv4?(addr) || valid_ipv6?(addr)
    end

    def self.valid_ipv4?(addr)
      if /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ =~ addr
        return $~.captures.all? {|i| i.to_i < 256}
      end
      false
    end

    def self.valid_ipv6?(addr)
      # https://gist.github.com/cpetschnig/294476
      # http://forums.intermapper.com/viewtopic.php?t=452
      return true if /^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/ =~ addr
      false
    end

    def self.is_domestic?(addr)
      ip_region = Ipnet.find_by_ip(addr)
      ['中国', '本机地址', '局域网', '共享地址'].include?(ip_region[:country]) && !['香港', '台湾'].include?(ip_region[:province]) || ip_region[:country].blank?
    end

    def self.country(addr)
      ip_region = Ipnet.find_by_ip(addr)
      if ip_region
        ip_region[:country]
      else
        "香港"
      end
    end

    def self.is_share_address?(addr)
      return false if addr.blank?
      net = IPAddr.new("100.64.0.0/10")
      net.include?(addr)
    end

    def self.is_private_ip?(addr)
      return false if addr.blank?
      prefix = addr.split(".")&.first
      range = IP_RANGE[prefix.to_sym]
      return false if range.nil?
      range.each do |r|
        return true if r.include?(addr)
      end
      false
    end

  end

  def self.remaining_time
    Time.now.end_of_day - Time.now
  end

  # 将时间戳转换为精度为分钟的时间戳
  def self.convert2minute(ts)
    DateTime.parse(Time.at(ts).strftime("%Y-%m-%d %H:%M")).to_i
  end

  def self.valid_password?(pwd)
    (/[^A-Za-z0-9~!@#$%^&*()]+/ =~ pwd) == nil
  end

  # 是否包含中文字符
  def self.include_han?(str)
    /\p{Han}+/u.match(str) != nil
  end

  # 时间戳转时间
  def self.ts2t(ts)
    # 如果是字符型，则转成整串
    ts = ts.is_a?(String) ? ts.to_i : ts
    # 如果带毫秒，则转成不带毫秒
    ts = ts.to_s.length == 13 ? (ts / 1000) : ts
    Time.at(ts)
  end

  def self.mb2b(mb)
    mb * 1000 * 1000
  end

  def self.b2mb(b)
    b > 1000 * 1000 ? b / 1000 / 1000 : 0
  end

  def self.g2b(g)
    g * 1000 * 1000 * 1000
  end

  def self.b2g(b, precision=4)
    "%.#{precision}f" % (b.to_f / GB)
  end

end
