class AddUserIdToMosaic < ActiveRecord::Migration
  def change
    add_column :mosaics, :user_id, :integer
  end
end
