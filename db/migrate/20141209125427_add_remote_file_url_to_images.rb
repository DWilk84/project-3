class AddRemoteFileUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :remote_file_url, :string
  end
end
