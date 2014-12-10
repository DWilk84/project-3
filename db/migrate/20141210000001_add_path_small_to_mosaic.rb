class AddPathSmallToMosaic < ActiveRecord::Migration
  def change
    add_column :mosaics, :path_small, :string
  end
end
