require 'rails_helper'

describe Newsletters::SubscriptionConfirmationService do
  let(:mail_from) { 'newsletter@test.com' }

  subject { described_class.new(mail_from, mail_body) }

  describe '#confirm' do
    before do
      allow(HTTParty).to receive(:get)
    end

    context 'when there is no `confirm` word in mail body' do
      let(:mail_body) do
        JSON.parse(
          IO.read(
            Rails.root.join(
              'spec', 'fixtures', 'mailgun', 'spam_mail.json'
            )
          )
        )['body-html']
      end

      it 'returns nil' do
        expect(subject.confirm).to be_nil
      end
    end

    context 'when there is `confirm` word in mail body' do
      let(:mail_body) do
        JSON.parse(
          IO.read(
            Rails.root.join(
              'spec', 'fixtures', 'mailgun', 'newsletter_confirmation_mail.json'
            )
          )
        )['body-html']
      end

      it 'clicks every link included in mail body' do
        expect(HTTParty).to receive(:get).with(
          'http://austinkleon.us1.list-manage1.com/subscribe/confirm?u=25a34f10515c4e9393e3da856&id=280158dda1&e=3c024244ad'
        ).once
        expect(HTTParty).to receive(:get).with(
          anything
        ).exactly(12).times

        subject.confirm
      end

      it 'creates newsletter' do
        expect { subject.confirm }.to change {
          Newsletter.count
        }.by(1)

        newsletter = Newsletter.last
        expect(newsletter.email).to eq(mail_from)
        expect(newsletter.confirmation_urls).to eq(
          [
            "http://austinkleon.us1.list-manage1.com/subscribe/confirm?u=25a34f10515c4e9393e3da856&id=280158dda1&e=3c024244ad",
            "http://www.",
            "http://austinkleon.us1.list-manage1.com/images/vcar=",
            "http://austinkleon.us1.list-manage1.com/images/hcar=", "https://gallery.mailchimp.com/25a34f10515c4e9393e3d=", "http://austinkleon.us1.list-manage1.com/subscri=", "http://schema.org/EmailMessage", "http://schema.org/Confirm=", "http://schema.org/Http=", "https://austinkleon.us1.list-manage", "http://schema.org/HttpRequestMethod=", "http://www.mailchimp.com/monkey-rewards/?utm_source=3Dfreemium_news=", "http://gallery."]
        )
      end
    end
  end
end
