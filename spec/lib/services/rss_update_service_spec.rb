require 'spec_helper'

describe RSSUpdateService do

  let!(:newsletter) do
    FactoryGirl.create(:newsletter)
  end

  describe '#update' do
    context 'when there is one mail' do
      before do
        allow(Mail).to receive(:find).and_return(
          [mail]
        )
      end

      context 'and it comes from newsletter' do
        let(:mail) do
          instance_double(
            'Mail::Message',
            from: [newsletter.email],
            subject: 'Check out new buttons!'
          )
        end

        context 'and this mail was already converted to RSS item' do
          let!(:rss_item) do
            FactoryGirl.create(
              :rss_item, newsletter: newsletter, subject: mail.subject
            )
          end

          it 'does not create RSS item' do
            expect { subject.update }.to_not change {
              RSSItem.count
            }
          end
        end

        context 'and this mail was not yet converted to RSS item' do
          it 'creates RSS item' do
            expect { subject.update }.to change {
              newsletter.rss_items.count
            }.by(1)
          end
        end
      end

      context 'and it does not come from newsletter' do
        let(:mail) do
          instance_double(
            'Mail::Message',
            from: ['test@example.com'],
            subject: 'Some new spam, check out!'
          )
        end

        it 'does not create RSS item' do
          expect { subject.update }.to_not change {
            RSSItem.count
          }
        end
      end
    end
  end

end
