ENV['RACK_ENV'] = 'test'
require_relative '../config/application'
Bundler.require(:test)
require_all File.expand_path('../factories/*.rb', __FILE__)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.clean
  end

  config.before(:each) do |example|
    DatabaseCleaner.start
  end

  config.after(:each) do |example|
    DatabaseCleaner.clean
  end
end
