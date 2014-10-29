class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:update]

  def show
    @collection = Collection.find_by(uid: params[:uid])
  end

  def update
    Collection.initialize_or_update(params["delta"]["users"])

    respond_to do |format|
      format.text { render text: "success" }
    end
  end
end
