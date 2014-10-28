class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :display_name
      t.integer :dropbox_uid
      t.string :email

      t.timestamps
    end
  end
end
