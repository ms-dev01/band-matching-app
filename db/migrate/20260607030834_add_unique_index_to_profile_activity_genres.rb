class AddUniqueIndexToProfileActivityGenres < ActiveRecord::Migration[8.1]
  def change
    add_index :profile_activity_genres,
    [ :profile_id, :activity_genre_id ],
    unique: true
  end
end
