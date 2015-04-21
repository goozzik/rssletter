require 'bundler/setup'
Bundler.require(:default)

require_all File.expand_path('../../lib/services/*.rb', __FILE__)
require_all File.expand_path('../../lib/models/*.rb', __FILE__)

class Rssletter < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  def self.env
    @@env ||= ENV['RACK_ENV'] || 'development'
  end

  def self.config
    @@config ||= YAML.load(
      ERB.new(
        File.read(
          File.expand_path('../application.yml', __FILE__)
        )
      ).result
    )[env]
  end

end

Mail.defaults do
  retriever_method(
    Rssletter.config[:mail][:retriever_method].to_sym,
    Rssletter.config[:mail].except(:retriever_method)
  )
end
