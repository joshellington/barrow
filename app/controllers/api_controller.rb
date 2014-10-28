class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:update]

  def show
    @collection = Collection.find_by(uid: params[:uid])
  end

  def update
    users = params["delta"]["users"]

    users.each do |user_id|
      @user = User.find_by(dropbox_uid: user_id)
      client = DropboxClient.new(@user["access_token"])
      @delta = client.delta(nil, '/Barrow')

      @delta["entries"].each do |file|
        if file[1]["is_dir"]
          Collection.where(dropbox_path: file[1]["path"]).first_or_create do |collection|
            collection.dropbox_path = file[1]["path"]
            collection.user_id = @user.id
            collection.save!
          end
        end
      end
    end

    respond_to do |format|
      format.text { render text: "success" }
    end
  end

  private
  def dropbox_thumbnail(path, access_token, size = 'large')
    extension = File.extname(path)
    write_path = "#{Rails.root}/public/#{File.basename(path, extension)}-#{size}#{extension}"
    public_path = "/#{File.basename(path, extension)}-#{size}#{extension}"

    unless File.file?(write_path)
      puts path
      if path
        client = DropboxClient.new(access_token)
        thumb = client.thumbnail_and_metadata(path, size)
        File.open(write_path, 'w+'){|f| f.write thumb[0].to_s.force_encoding("UTF-8") }
      end
    else
      puts "#{write_path} exists!"
    end

    return public_path
  end
end
