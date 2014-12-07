class Image < ActiveRecord::Base
  attr_accessible :name, :file, :mosaic_id, :user_id

  mount_uploader :file, ImageUploader

  belongs_to :user
  has_and_belongs_to_many :mosaics
end
