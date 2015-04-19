require 'bundler/setup'
Bundler.require(:default)

require_all File.expand_path('../../lib/*.rb', __FILE__)

class Rssletter < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end
