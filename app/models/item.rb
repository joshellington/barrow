class Item < ActiveRecord::Base
  after_save :save_file
  
  belongs_to :collection

  def save_file
    puts self.collection.user.access_token
    puts self.path

    extension = File.extname(self.path)
    write_path = "#{Rails.root}/public/#{self.collection.id}/#{File.basename(self.path, extension)}#{extension}"
    public_path = "/#{self.collection.id}/#{File.basename(self.path, extension)}#{extension}"

    unless File.file?(write_path)
      if self.path
        client = DropboxClient.new(self.collection.user.access_token)
        thumb = client.get_file(self.path)
        File.open(write_path, 'w+'){|f| f.write thumb.to_s.force_encoding("UTF-8") }
        self.public_path = public_path
        self.save
      end
    end

    return public_path
  end
end
