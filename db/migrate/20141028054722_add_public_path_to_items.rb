class AddPublicPathToItems < ActiveRecord::Migration
  def change
    add_column :items, :public_path, :string
  end
end
