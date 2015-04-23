class CreateRssItems < ActiveRecord::Migration

  def change
    create_table :rss_items do |t|
      t.string :title
      t.text :content
      t.integer :newsletter_id

      t.timestamps
    end
  end

end
