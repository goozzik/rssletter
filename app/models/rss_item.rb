class RSSItem < ActiveRecord::Base
  belongs_to :newsletter, touch: true
end
