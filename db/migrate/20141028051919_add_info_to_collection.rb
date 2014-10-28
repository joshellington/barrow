class AddInfoToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :info, :text
  end
end
