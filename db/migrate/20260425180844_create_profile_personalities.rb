class CreateProfilePersonalities < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_personalities do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :personality, null: false, foreign_key: true

      t.timestamps
    end
  end
end
