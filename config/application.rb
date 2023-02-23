require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApp
  class Application < Rails::Application
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, "zh-CN"]
    config.i18n.default_locale = "zh-CN"

    # Rails 5 disables autoloading after booting the app in production
    # http://blog.bigbinary.com/2016/08/29/rails-5-disables-autoloading-after-booting-the-app-in-production.html
    config.enable_dependency_loading = true
    config.eager_load_paths += %W(
      #{Rails.root}/lib
      #{Rails.root}/app/services
    )

    # 改用load的方式在route.rb文件中加载
    Dir[Rails.root.join('config/routes/*.rb')].sort.each do  |f|
      config.paths["config/routes.rb"].push(f)
    end

    # set default url
    Rails.application.routes.default_url_options = {
      host: Rails.application.secrets.host_url
    }

    # redis
    config.cache_store = :redis_store, {
      host: Rails.application.secrets.redis_host,
      port: Rails.application.secrets.redis_port,
      db: Rails.application.secrets.redis_db,
      password: Rails.application.secrets.redis_pwd,
      namespace: Rails.application.secrets.redis_namespace,
      expires_in: 12.hours # 过期时间的设置
    }

    # sidekiq
    config.active_job.queue_adapter = :sidekiq

    # skip generate assets and helper files
    config.generators do |cfg|
      cfg.orm :active_record
      cfg.stylesheets false
      cfg.javascripts false
      cfg.assets false
      cfg.helper false
      cfg.test_framework nil
    end

    # Avoid CORS issues when API is called from the frontend app.
    # Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.
    # Read more: https://github.com/cyu/rack-cors
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :delete, :put, :patch, :options, :head]
      end
    end

  end
end

# config
CONFIG = Rails.application.secrets