class AddTitleToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :title, :string
  end
end
