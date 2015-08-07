class Bill < ActiveRecord::Base
 belongs_to :claim
 mount_uploader :file, FileUploader

  before_save :update_file_attributes
  private

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.content_type
      
    end
  end

end
