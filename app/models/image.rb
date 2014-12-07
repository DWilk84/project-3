class Image < ActiveRecord::Base
  attr_accessible :mosaic_id, :name, :file

  mount_uploader :file, ImageUploader
end
