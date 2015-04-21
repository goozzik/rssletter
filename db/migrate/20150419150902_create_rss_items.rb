class CreateRssItems < ActiveRecord::Migration

  def change
    create_table :rss_items do |t|
      t.string :subject
      t.text :body
      t.integer :newsletter_id

      t.timestamps
    end
  end

end
