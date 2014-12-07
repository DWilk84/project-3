class Image < ActiveRecord::Base
  attr_accessible :mosaic_id, :name, :file, :user_id

  mount_uploader :file, ImageUploader

  belongs_to :user
end
