class CreateActivityAreas < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_areas do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
