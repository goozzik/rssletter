class Newsletter < ActiveRecord::Base
  has_many :rss_items, dependent: :destroy, class_name: 'RSSItem'
end
