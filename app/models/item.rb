class Item < ActiveRecord::Base
  after_save :save_file
  
  belongs_to :collection

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :image,
  styles: {
    thumb: '100x100>',
    square: '600x600#',
    medium: '600x600>',
    large: '1280x800>',
    xl: '1650x1050>'
  },
  path: ":rails_root/public/system/:attachment/:id_partition/:style/:hash.:extension",
  url: "/system/:attachment/:id_partition/:style/:hash.:extension",
  hash_secret: 'callMeBigPoppa'

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def save_file
    Resque.enqueue(SaveItem, self.id)
  end
end
