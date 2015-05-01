class CreateNewsletterItems < ActiveRecord::Migration
  def change
    create_table :newsletter_items do |t|
      t.string :title
      t.text :content
      t.integer :newsletter_id

      t.timestamps
    end
  end
end
