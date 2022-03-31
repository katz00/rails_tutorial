source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails',        '5.2.4'
gem 'puma',         '4.3.12'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'
gem 'bootstrap', '>= 4.3.1'
gem 'bcrypt', '3.1.13'
gem 'faker', '1.9.1'
gem 'kaminari', '1.2.0'
gem 'carrierwave', '2.0.1'
gem 'mini_magick', '4.9.5'


group :development, :test do
  gem 'sqlite3', '1.4.0'
  gem 'byebug',  '11.0.0', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest',                 '5.10.3'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  gem 'pg', '0.20.0'
  gem 'fog', '2.2.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
gem 'tzinfo-data'