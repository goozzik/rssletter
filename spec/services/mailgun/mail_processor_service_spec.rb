require 'rails_helper'

describe Mailgun::MailProcessorService do
  subject { described_class.new(params) }

  describe '#process' do
    context 'when there is no `List-Unsubscribe` param' do
      let(:params) do
        JSON.parse(
          IO.read(
            Rails.root.join('spec', 'fixtures', 'mailgun', 'spam_mail.json')
          )
        )
      end

      it 'returns nil' do
        expect(subject.process).to be_nil
      end
    end

    context 'when there is `List-Unsubscribe` param' do
      let(:params) do
        JSON.parse(
          IO.read(
            Rails.root.join('spec', 'fixtures', 'mailgun', 'newsletter_mail.json')
          )
        )
      end

      context 'and there is newsletter with email matching given `from` param' do
        let!(:newsletter) { Newsletter.create(email: params['from']) }

        it 'creates newsletter item for existing newsletter' do
          expect { subject.process }.to change { newsletter.items.count }.by(1)
        end
      end

      context 'and there is no newsletter with email matching given `from` param' do
        it 'creates newsletter' do
          expect { subject.process }.to change { Newsletter.count }.by(1)

          newsletter = Newsletter.last
          expect(newsletter.email).to eq(params['from'])
        end

        it 'creates newsletter item' do
          expect { subject.process }.to change { NewsletterItem.count }.by(1)

          newsletter_item = NewsletterItem.last
          expect(newsletter_item.content).to match(
            'Witam Cię serdecznie w gronie subskrybentów mojego newslettera'
          )
          expect(newsletter_item.title).to eq(params['subject'])
        end
      end
    end
  end
end
