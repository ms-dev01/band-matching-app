class CreateProfileActivityGenres < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_activity_genres do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :activity_genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
