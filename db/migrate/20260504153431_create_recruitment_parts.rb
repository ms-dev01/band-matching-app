class CreateRecruitmentParts < ActiveRecord::Migration[8.1]
  def change
    create_table :recruitment_parts do |t|
      t.references :band_recruitment, null: false, foreign_key: true
      t.integer :part, null: false
      t.integer :max_count, null: false

      t.timestamps
    end
  end
end
