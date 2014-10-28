class Collection < ActiveRecord::Base
  before_create :set_uid

  protected
    def set_uid
      # This only works before_create obviously, otherwise it would
      # find itself and loop eternally.
      while self.uid.blank? or !Album.find_by_uid(self.uid).blank?
        self.uid = Digest::SHA1.hexdigest("--#{self.id}--#{Time.current.usec}--")
      end
    end
end
