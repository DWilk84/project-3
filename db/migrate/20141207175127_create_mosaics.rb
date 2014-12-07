class CreateMosaics < ActiveRecord::Migration
  def change
    create_table :mosaics do |t|
      t.string :name

      t.timestamps
    end
  end
end
