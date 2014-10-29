class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:update]

  def show
    @collection = Collection.find_by(uid: params[:uid])
  end

  def update
    users = params["delta"]["users"]

    users.each do |user_id|
      @user = User.find_by(dropbox_uid: user_id)
      if @user
        client = DropboxClient.new(@user["access_token"])
        @delta = client.delta(nil, '/Barrow')

        @delta["entries"].each do |file|
          if file[1]["is_dir"]
            collection = Collection.find_by(dropbox_path: file[1]["path"])

            if collection
              collection.save
            else
              collection = Collection.new
              collection.dropbox_path = file[1]["path"]
              collection.user = @user
              collection.save
            end
          end
        end

        @msg = "success"
      else
        @msg = "user does not exist"
      end
    end

    respond_to do |format|
      format.text { render text: @msg }
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
