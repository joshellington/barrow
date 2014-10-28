class PagesController < ApplicationController
  def home
    @current_user = current_user
    @authorize_url = DROPBOX.start()
  end

  def about
  end
end
