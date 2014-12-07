class CreateImagesMosaics < ActiveRecord::Migration
  def change
    create_table :images_mosaics, id: false do |t|
      t.integer :image_id
      t.integer :mosaic_id
    end
  end
end
