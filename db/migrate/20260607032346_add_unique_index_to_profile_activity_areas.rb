class AddUniqueIndexToProfileActivityAreas < ActiveRecord::Migration[8.1]
  def change
    add_index :profile_activity_areas,
    [ :profile_id, :activity_area_id ],
    unique: true
  end
end
