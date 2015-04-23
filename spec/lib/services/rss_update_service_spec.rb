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
        let(:mail_body) do
          instance_double(
            'Mail::Body',
            parts: [],
            raw_source: 'Something really interesting.'
          )
        end
        let(:mail) do
          instance_double(
            'Mail::Message',
            from: [newsletter.email],
            subject: 'Check out new buttons!',
            body: mail_body,
          )
        end

        context 'and this mail was already converted to RSS item' do
          let!(:rss_item) do
            FactoryGirl.create(
              :rss_item, newsletter: newsletter, title: mail.subject
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

            rss_item = newsletter.rss_items.last
            expect(rss_item.title).to eq(mail.subject)
          end

          context 'and there is only one format of mail body' do
            it 'assigns raw source of mail body as RSS item content' do
              subject.update

              rss_item = newsletter.rss_items.last
              expect(rss_item.content).to eq(mail.body.raw_source)
            end
          end

          context 'and there are text/plain and text/html body formats' do
            let(:mail_html_body_part) do
              instance_double(
                'Mail::Part',
                content_type: "text/html; charset=ascii",
                body: instance_double('Mail::Body', raw_source: '<html></html>')
              )
            end
            let(:mail_plain_body_part) do
              instance_double(
                'Mail::Part',
                content_type: "text/plain; charset=ascii",
                body: instance_double('Mail::Body', raw_source: 'raw')
              )
            end
            let(:mail_body_parts) do
              [mail_html_body_part, mail_plain_body_part]
            end

            before do
              allow(mail_body).to receive(:parts).and_return(mail_body_parts) 
            end

            it 'assigns text/html format of mail body as RSS item content' do
              subject.update

              rss_item = newsletter.rss_items.last
              expect(rss_item.content).to eq(mail_html_body_part.body.raw_source)
            end
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
