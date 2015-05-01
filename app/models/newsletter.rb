class Newsletter < ActiveRecord::Base
  has_many :items, dependent: :destroy, class_name: 'NewsletterItem'
end
