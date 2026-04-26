class CreateFavoriteBands < ActiveRecord::Migration[8.1]
  def change
    create_table :favorite_bands do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
