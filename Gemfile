source 'https://rubygems.org'

gem 'rails', '4.2.5'

### App Server ###
gem 'thin'

### Assets ###
gem 'coffee-rails', '~> 4.1'
gem 'jquery-rails', '~> 4.0', '>= 4.0.5'
gem 'uglifier',     '>= 2.6' # Compressor for JavaScript assets.

group :development, :test do
  gem 'rake', '~> 10.4.2' # Required for Travis-CI.

  gem 'rspec',                       '~> 3.4'
  gem 'rspec-rails',                 '~> 3.4'
  gem 'rspec-sleeping_king_studios', '>= 2.1.0', :git => 'https://github.com/sleepingkingstudios/rspec-sleeping_king_studios'

  gem 'byebug', '~> 8.2', '>= 8.2.1'
end # group

group :development do
  gem 'web-console', '~> 2.0'
end # group

gem 'rails_12factor', :group => :production # Required for Heroku deployment.
