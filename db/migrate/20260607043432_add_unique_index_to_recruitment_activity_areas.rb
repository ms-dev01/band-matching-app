class AddUniqueIndexToRecruitmentActivityAreas < ActiveRecord::Migration[8.1]
  def change
    add_index :recruitment_activity_areas,
    [ :band_recruitment_id, :activity_area_id ],
    unique: true
  end
end
