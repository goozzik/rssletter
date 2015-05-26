module Newsletters
  class SubscriptionConfirmationService
    def initialize(mail_from, mail_body)
      self.mail_from = mail_from
      self.mail_body = mail_body.gsub(/\s+/, " ")
    end

    def confirm
      return nil unless possible_confirmation_mail?

      possible_confirmation_urls.each do |url|
        send_confirmation_request(url)
      end

      create_newsletter
    end

    private

    attr_accessor :mail_from, :mail_body

    def possible_confirmation_mail?
      mail_body.match(/confirm/i)
    end

    def possible_confirmation_urls
      @possible_confirmation_urls ||= URI.extract(
        mail_body, ['http', 'https']
      ).map { |url| url.gsub(/\)$/, '') }
    end

    def send_confirmation_request(url)
      HTTParty.get(url)
    rescue
      nil
    end

    def create_newsletter
      Newsletter.create(
        email: mail_from,
        confirmation_urls: possible_confirmation_urls
      )
    end
  end
end
