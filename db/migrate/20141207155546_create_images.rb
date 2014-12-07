class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :mosaic_id
      t.string :name

      t.timestamps
    end
  end
end
