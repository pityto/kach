require 'sidekiq/cron' if CONFIG.schedule_job_enabled

redis_url = "redis://#{CONFIG.redis_host}:#{CONFIG.redis_port}/#{CONFIG.redis_db}"

# 使用单独的redis.yml配置
# Rails.application.config_for(:redis)

$redis_connection = Redis.new(url: redis_url, password: CONFIG.redis_pwd)
$redis = Redis::Namespace.new(CONFIG.redis_namespace, redis: $redis_connection)

Redis::Objects.redis = $redis

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'sidekiq', url: redis_url, password: CONFIG.redis_pwd }
  schedule_file = 'config/schedule.yml'
  if File.exists?(schedule_file) && defined?(Sidekiq::Cron) && Sidekiq.server? && CONFIG.schedule_job_enabled
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'sidekiq', url: redis_url, password: CONFIG.redis_pwd }
end