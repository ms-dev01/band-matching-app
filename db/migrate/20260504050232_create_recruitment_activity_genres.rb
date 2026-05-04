class CreateRecruitmentActivityGenres < ActiveRecord::Migration[8.1]
  def change
    create_table :recruitment_activity_genres do |t|
      t.references :band_recruitment, null: false, foreign_key: true
      t.references :activity_genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
