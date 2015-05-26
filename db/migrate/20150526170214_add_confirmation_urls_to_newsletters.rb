class AddConfirmationUrlsToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :confirmation_urls, :string
  end
end
