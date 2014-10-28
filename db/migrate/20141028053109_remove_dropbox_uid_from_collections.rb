class RemoveDropboxUidFromCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :dropbox_uid, :integer
  end
end
