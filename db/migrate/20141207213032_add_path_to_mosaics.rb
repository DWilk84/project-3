class AddPathToMosaics < ActiveRecord::Migration
  def change
    add_column :mosaics, :path, :string
  end
end
