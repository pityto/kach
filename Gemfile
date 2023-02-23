source 'https://mirrors.tuna.tsinghua.edu.cn/rubygems'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.3'

gem 'rack-attack', '~> 5.0'
gem 'rack-cors', require: 'rack/cors'
gem 'mysql2', '~> 0.5'
gem 'redis', '~> 3.3'
gem 'redis-namespace', '~> 1.5'
gem 'redis-rails', '~> 5.0'
gem 'redis-objects', '~> 1.3'
gem 'sidekiq', '~> 4.2'
gem 'sidekiq-cron', '~> 0.4.5', require: false
gem 'uuidtools', '~> 2.1'
gem 'kaminari', '~> 1.0'
gem 'jwt', '~> 1.5', '>= 1.5.6'
gem 'rest-client', '~> 2.0'
gem 'active_record_bulk_insert', '~> 1.3'
gem 'rails-settings-cached', '~> 0.6.5'
# log
gem 'logstasher', '~> 1.2'
# top-level parse
gem 'public_suffix', '~> 2.0'
# IAP pay
#gem 'monza', '~> 0.1.4'
gem 'monza', github: 'gabrielgarza/monza'
gem 'aasm', '~> 4.12'
gem 'qiniu', '~> 6.8.1'

gem 'rails', '6.1.4'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
#gem 'jquery-rails'
#gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
#gem 'minitest', '~> 5.10'
gem 'listen'
gem 'bootsnap'
gem 'pry'
gem 'pry-rails'
gem 'httparty'
gem 'rubyzip', '>= 1.0.0'
gem 'zip-zip'
gem 'ruby-rc4'
gem 'whenever', require: false
gem 'fluent-logger'
gem "therubyracer"
# excel
gem 'spreadsheet'
gem 'roo-xls', github: 'roo-rb/roo-xls'

# 数据库
gem 'mongo'

gem 'cancancan'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :production do
  #gem 'ddtrace'
end

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  #gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'


  # static code analyzer, based on the community ruby style guide
  #gem 'rubocop', '~> 0.48.1', require: false
  # static analysis security vulnerability scanner
  #gem 'brakeman', '~> 3.6', require: false

  gem 'mina', '~> 0.3.8', require: false
  gem 'mina-puma', :require => false
  gem 'mina-sidekiq', '~> 0.4.1', require: false
  gem 'mina-multistage', '~> 1.0', '>= 1.0.2', require: false

  #gem 'mina', '~> 1.0.6'
  #gem 'mina-puma', '~> 1.0'G
  #gem 'mina-sidekiq', '~> 1.0'
  #gem 'mina-multistage', '~> 1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
