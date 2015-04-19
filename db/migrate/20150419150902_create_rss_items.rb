class CreateRssItems < ActiveRecord::Migration

  def change
    create_table :rss_items do |t|
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

end
