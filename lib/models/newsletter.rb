require 'rss'

class Newsletter < ActiveRecord::Base

  has_many :rss_items, dependent: :destroy, class_name: 'RSSItem'

  def to_rss
    RSS::Maker.make('atom') do |maker|
      maker.channel.title = title
      maker.channel.author = title
      maker.channel.id = id.to_s
      maker.channel.updated = Time.now.to_s

      rss_items.each do |rss_item|
        maker.items.new_item do |item|
          item.id = rss_item.id.to_s
          item.description = rss_item.content
          item.title = rss_item.title
          item.updated = rss_item.created_at
        end
      end
    end.to_s
  end

end
