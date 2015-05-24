module Mailgun
  class MailProcessorService
    def initialize(params)
      self.params = params
    end

    def process
      return if not_newsletter_mail?

      @newsletter = create_or_find_newsletter
      create_newsletter_item
    end

    private

    attr_accessor :params

    def not_newsletter_mail?
      !params.keys.any? { |k| k.match(/list-unsubscribe/i) }
    end

    def create_or_find_newsletter
      newsletter = Newsletter.find_by(email: params['from'])
      newsletter ||= Newsletter.create(email: params['from'])
      newsletter
    end

    def create_newsletter_item
      @newsletter.items.create(
        title: params['subject'],
        content: params['body-html']
      )
    end
  end
end
