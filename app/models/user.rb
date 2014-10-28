class User < ActiveRecord::Base

  def self.from_dropbox(account_info, response)
    if account_info and response
      create_from_dropbox(account_info, response)
    end
  end

  def self.create_from_dropbox(account_info, response)
    pp account_info
    pp response

    create! do |user|
      user.dropbox_uid = response[1]
      user.display_name = account_info["display_name"]
      user.email = account_info["email"]
      user.access_token = response[0]
    end
  end
end
