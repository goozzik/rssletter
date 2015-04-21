class CreateNewsletters < ActiveRecord::Migration

  def change
    create_table :newsletters do |t|
      t.string :name
      t.string :domain
      t.string :email

      t.timestamps
    end
  end

end
