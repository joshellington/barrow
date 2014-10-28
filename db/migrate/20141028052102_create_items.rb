class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :path
      t.string :rev
      t.string :client_mtime
      t.string :icon
      t.integer :bytes
      t.string :modified
      t.string :size
      t.string :root
      t.string :mime_type
      t.integer :revision

      t.timestamps
    end
  end
end
