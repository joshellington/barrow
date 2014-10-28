class UsersController < ApplicationController
  def show
    if session[:user_id]
      @user = current_user
      @client = DropboxClient.new(current_user["access_token"])
      @collections = Collection.where(user: @user)

      @data = []
      
      @collections.each do |collection|
        items = Item.where(collection: collection)

        if items.size > 0
          data = {
            "collection" => collection,
            "items" => items
          }

          @data << data
        end
      end

      begin
        @folders = @client.metadata('/Barrow/dan')
      rescue
        @folders = @client.file_create_folder('/Barrow')
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
end
