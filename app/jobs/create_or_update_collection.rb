class CreateOrUpdateCollection
  @queue = :create_or_update_collection

  def self.perform(user)
    client = DropboxClient.new(user["access_token"])
    @delta = client.delta(nil, '/Barrow')

    @delta["entries"].each do |file|
      if file[1]["is_dir"]
        collection = Collection.find_by(dropbox_path: file[1]["path"])

        if collection
          collection.save
        else
          collection = Collection.new
          collection.dropbox_path = file[1]["path"]
          collection.user_id = user["id"]
          collection.save
        end
      end
    end
  end
end