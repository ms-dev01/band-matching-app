class CreateProfileFavoriteBands < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_favorite_bands do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :favorite_band, null: false, foreign_key: true

      t.timestamps
    end
  end
end
