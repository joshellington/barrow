module UsersHelper
  def dropbox_thumbnail(path, size = 'large')
    extension = File.extname(path)
    write_path = "#{Rails.root}/public/#{File.basename(path, extension)}-#{size}#{extension}"
    public_path = "/#{File.basename(path, extension)}-#{size}#{extension}"

    unless File.file?(write_path)
      if current_user and path
        client = DropboxClient.new(current_user["access_token"])
        thumb = client.thumbnail_and_metadata(path, size)
        File.open(write_path, 'w+'){|f| f.write thumb[0].to_s.force_encoding("UTF-8") }
      end
    end

    return public_path
  end
end
