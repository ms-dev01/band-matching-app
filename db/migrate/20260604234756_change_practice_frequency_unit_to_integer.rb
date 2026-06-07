class ChangePracticeFrequencyUnitToInteger < ActiveRecord::Migration[8.1]
  def up
    remove_column :band_recruitments, :practice_frequency_unit
    add_column :band_recruitments, :practice_frequency_unit, :integer
  end

  def down
    remove_column :band_recruitments, :practice_frequency_unit
    add_column :band_recruitments, :practice_frequency_unit, :string
  end
end
