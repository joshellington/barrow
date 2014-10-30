class FixInfoColumnNameForCollections < ActiveRecord::Migration
  def change
    rename_column :collections, :info, :description
  end
end
