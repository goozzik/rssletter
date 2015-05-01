class NewsletterItem < ActiveRecord::Base
  belongs_to :newsletter, touch: true
end
