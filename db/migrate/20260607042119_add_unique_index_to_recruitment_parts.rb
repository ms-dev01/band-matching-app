class AddUniqueIndexToRecruitmentParts < ActiveRecord::Migration[8.1]
  def change
    add_index :recruitment_parts,
    [ :band_recruitment_id, :part ],
    unique: true
  end
end
