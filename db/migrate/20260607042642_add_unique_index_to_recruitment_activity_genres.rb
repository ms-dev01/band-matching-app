class AddUniqueIndexToRecruitmentActivityGenres < ActiveRecord::Migration[8.1]
  def change
    add_index :recruitment_activity_genres,
    [ :band_recruitment_id, :activity_genre_id ],
    unique: true
  end
end
