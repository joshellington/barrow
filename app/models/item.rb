class Item < ActiveRecord::Base
  after_save :save_file
  
  belongs_to :collection

  def save_file
    Resque.enqueue(SaveItem, self.id)
  end
end
