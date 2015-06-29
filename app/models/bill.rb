class Bill < ActiveRecord::Base
 belongs_to :claim
 mount_uploader :file, FileUploader
end
