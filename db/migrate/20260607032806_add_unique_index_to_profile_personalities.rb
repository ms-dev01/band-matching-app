class AddUniqueIndexToProfilePersonalities < ActiveRecord::Migration[8.1]
  def change
    add_index :profile_personalities,
    [ :profile_id, :personality_id ],
    unique: true
  end
end
