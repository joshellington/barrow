class SaveItem
  @queue = :save_item

  def self.perform(item_id)
    item = Item.find(item_id)

    if item and item["path"]
      extension = File.extname(item["path"])
      write_path = "#{Rails.root}/public/uploads/#{item.collection["uid"]}/#{File.basename(item["path"], extension)}#{extension}"
      public_path = "/uploads/#{item.collection["uid"]}/#{File.basename(item["path"], extension)}#{extension}"

      client = DropboxClient.new(item.collection.user["access_token"])

      begin
        thumb = client.get_file_and_metadata(item["path"])
        unless File.file?(write_path)
          File.open(write_path, 'w+') do |f|
            f.write(thumb[0].to_s.force_encoding("UTF-8"))
            item.public_path = public_path
            item.image = f
            item.save
          end
        end
      rescue RuntimeError => e
        puts e.inspect
        if e is "File has been deleted"
          item.destroy
        end
      end
    end
  end
end