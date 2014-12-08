class AddAuthTokenToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :auth_token, :text
  end
end
