source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

gem 'rails', '~> 7.0.3', '>= 7.0.3.1'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'puma', '~> 5.0'
gem 'importmap-rails'
gem 'turbo-rails', '~> 1.4'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis', '~> 4.0'

gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'bootsnap', require: false

## Database
gem 'pg', '~> 1.1'

## Vector Database
gem 'neighbor'

## OpenAI
gem 'ruby-openai'

## Hugging Face
gem 'hugging-face'

## Net HTTP
gem 'net-http'

## Sidekiq
gem 'sidekiq'

group :development, :test do
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
