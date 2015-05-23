module Mailgun
  class AuthenticationService
    def initialize(token, timestamp, signature)
      self.token = token
      self.timestamp = timestamp
      self.signature = signature
    end

    def verify
      digest = OpenSSL::Digest::SHA256.new
      data = [timestamp, token].join
      signature == OpenSSL::HMAC.hexdigest(digest, api_key, data)
    end

    private

    attr_accessor :token, :timestamp, :signature

    def api_key
      Settings.mailgun.api_key
    end
  end
end
