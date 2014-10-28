class SaveItem
  @queue = :save_item

  def self.perform(item_id)
    item = Item.find(item_id)

    if item
      extension = File.extname(item["path"])
      write_path = "#{Rails.root}/public/#{item.collection["id"]}/#{File.basename(item["path"], extension)}#{extension}"
      public_path = "/#{item.collection["id"]}/#{File.basename(item["path"], extension)}#{extension}"

      unless File.file?(write_path)
        if item["path"]
          client = DropboxClient.new(item.collection.user["access_token"])
          thumb = client.get_file(item["path"])
          File.open(write_path, 'w+'){|f| f.write thumb.to_s.force_encoding("UTF-8") }
          item.public_path = public_path
          item.save
        end
      end
    end
  end
end