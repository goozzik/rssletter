require 'rails_helper'

describe Newsletter do
  let(:newsletter) { FactoryGirl.create(:newsletter) }
  let(:rss_item) { FactoryGirl.create(:rss_item, newsletter: newsletter) }
  let(:utc_offset) { (Time.now.utc_offset / 3600).to_s }

  subject { newsletter }

  describe '#to_rss' do
    before do
      Timecop.freeze(Time.local(1990))
      rss_item
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
        "  <updated>1990-01-01T00:00:00+01:00</updated>\n"\
        "  <entry>\n"\
        "    <id>#{rss_item.id}</id>\n"\
        "    <summary>#{rss_item.content}</summary>\n"\
        "    <title>#{rss_item.title}</title>\n"\
        "    <updated>1989-12-31T23:00:00Z</updated>\n"\
        "    <dc:date>1989-12-31T23:00:00Z</dc:date>\n"\
        "  </entry>\n"\
        "  <dc:date>1990-01-01T00:00:00+01:00</dc:date>\n"\
        "</feed>"
      )
    end
  end
end

