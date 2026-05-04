class CreateRecruitmentActivityAreas < ActiveRecord::Migration[8.1]
  def change
    create_table :recruitment_activity_areas do |t|
      t.references :band_recruitment, null: false, foreign_key: true
      t.references :activity_area, null: false, foreign_key: true

      t.timestamps
    end
  end
end
