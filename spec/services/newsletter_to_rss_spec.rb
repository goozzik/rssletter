require 'rails_helper'

describe NewsletterToRSS do
  let(:newsletter) { FactoryGirl.create(:newsletter) }
  let(:newsletter_item) { FactoryGirl.create(:newsletter_item, newsletter: newsletter) }
  let(:utc_offset) { (Time.now.utc_offset / 3600).to_s }

  subject { described_class.new(newsletter) }

  describe '#to_rss' do
    before do
      Timecop.freeze(Time.local(1990))
      newsletter_item
    end

    after do
      Timecop.return
    end

    it 'returns RSS Atom XML representation of newsletter' do
      expect(subject.to_rss).to eq(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"\
        "<feed xmlns=\"http://www.w3.org/2005/Atom\"\n"\
        "  xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n"\
        "  <author>\n"\
        "    <name>#{newsletter.title}</name>\n"\
        "  </author>\n"\
        "  <id>#{newsletter.id}</id>\n"\
        "  <title>#{newsletter.title}</title>\n"\
        "  <updated>1989-12-31T23:00:00Z</updated>\n"\
        "  <entry>\n"\
        "    <id>#{newsletter_item.id}</id>\n"\
        "    <summary>#{newsletter_item.content}</summary>\n"\
        "    <title>#{newsletter_item.title}</title>\n"\
        "    <updated>1989-12-31T23:00:00Z</updated>\n"\
        "    <dc:date>1989-12-31T23:00:00Z</dc:date>\n"\
        "  </entry>\n"\
        "  <dc:date>1989-12-31T23:00:00Z</dc:date>\n"\
        "</feed>"
      )
    end

    context 'when given newsletter does not have title' do
      before { allow(newsletter).to receive(:title) { nil } }

      it 'uses newsletter email as RSS title and author' do
        rss_xml = Nokogiri::XML(subject.to_rss)

        expect(rss_xml.xpath("//xmlns:title").first.content).to eq(
          newsletter.email
        )
        expect(rss_xml.xpath("//xmlns:author/xmlns:name").first.content).to eq(
          newsletter.email
        )
      end
    end
  end
end
