class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :uid
      t.integer :dropbox_uid
      t.integer :user_id
      t.string :dropbox_path

      t.timestamps
    end
  end
end
