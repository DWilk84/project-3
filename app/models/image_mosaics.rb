class ImageMosaics < ActiveRecord::Base
  attr_accessible :mosaic_id, :image_id

  belongs_to :image
  belongs_to :mosaic
  
end