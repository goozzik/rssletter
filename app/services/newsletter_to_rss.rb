require 'rss'

class NewsletterToRSS
  def initialize(newsletter)
    self.newsletter = newsletter
  end

  def to_rss
    RSS::Maker.make('atom') do |maker|
      maker.channel.title = newsletter.title
      maker.channel.author = newsletter.title
      maker.channel.id = newsletter.id.to_s
      maker.channel.updated = newsletter.updated_at.to_s

      newsletter.rss_items.each do |rss_item|
        maker.items.new_item do |item|
          item.id = rss_item.id.to_s
          item.description = rss_item.content
          item.title = rss_item.title
          item.updated = rss_item.updated_at.to_s
        end
      end
    end.to_s
  end

  private

  attr_accessor :newsletter
end
