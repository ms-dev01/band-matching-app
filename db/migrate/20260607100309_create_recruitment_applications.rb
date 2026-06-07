class CreateRecruitmentApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :recruitment_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :band_recruitment, null: false, foreign_key: true
      # 参加希望コメント
      t.text :application_comment
      # 承認コメント
      t.text :approval_comment
      # 応募パート
      t.integer :application_part, null: false
      # 承認ステータス
      t.integer :status, null: false, default: 0
      t.timestamps
    end

    add_index :recruitment_applications,
    [ :user_id, :band_recruitment_id ],
    unique: true
  end
end
