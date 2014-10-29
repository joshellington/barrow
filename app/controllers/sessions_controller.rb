class SessionsController < ApplicationController
  def create
    @response = DROPBOX.finish(params)
    client = DropboxClient.new(@response[0])
    account_info = client.account_info()
    user = User.from_dropbox(account_info, @response)
    
    Collection.initialize_or_update([@response[1]])

    session[:user_id] = @response[1]
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
