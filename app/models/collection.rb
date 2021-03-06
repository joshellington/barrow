class Collection < ActiveRecord::Base
  before_create :set_uid
  after_create :create_folder
  after_save :create_items
  after_touch :create_items

  has_many :items
  belongs_to :user

  def self.initialize_or_update(users)
    users.each do |user_id|
      user = User.find_by(dropbox_uid: user_id)

      if user
        Resque.enqueue(CreateOrUpdateCollection, user)
      end
    end
  end

  protected
    def create_folder
      path = "#{Rails.root}/public/uploads/#{self.uid}"
      
      unless Dir.exist? path
        Dir.mkdir path
      end
    end

    def create_items
      @client = DropboxClient.new(self.user["access_token"])
      @folders = @client.metadata(self.dropbox_path)

      @folders["contents"].each do |content|
        unless content["is_dir"]
          is_info = [".yaml", ".yml"].any? {|ext| content["path"].include?(ext)}
          
          if is_info
            info = YAML.load(@client.get_file(content["path"]))
            self.update_columns(title: info["title"], description: info["description"])
          else
            Item.where(path: content["path"]).first_or_create do |item|
              item.path = content["path"]
              item.rev = content["rev"]
              item.client_mtime = content["client_mtime"]
              item.icon = content["icon"]
              item.bytes = content["bytes"]
              item.modified = content["modified"]
              item.size = content["size"]
              item.root = content["root"]
              item.mime_type = content["mime_type"]
              item.revision = content["revision"]
              item.collection = self
              item.save!
            end
          end
        end
      end
    end

    def set_uid
      while self.uid.blank? or !Collection.find_by_uid(self.uid).blank?
        self.uid = Digest::SHA1.hexdigest("--#{self.id}--#{Time.current.usec}--")
      end
    end
end
