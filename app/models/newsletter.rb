class Newsletter < ActiveRecord::Base
  has_many :items, dependent: :destroy, class_name: 'NewsletterItem'
  before_create :set_hash_id

  private

  def set_hash_id
    self.hash_id = Digest::SHA1.hexdigest(
      "#{Time.now.to_i}#{Newsletter.maximum(:id).to_i + 1}"
    )
  end
end
