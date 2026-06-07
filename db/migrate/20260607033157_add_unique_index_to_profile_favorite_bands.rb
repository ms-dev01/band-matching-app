class AddUniqueIndexToProfileFavoriteBands < ActiveRecord::Migration[8.1]
  def change
    add_index :profile_favorite_bands,
    [ :profile_id, :favorite_band_id ],
    unique: true
  end
end
