class CreateBandRecruitments < ActiveRecord::Migration[8.1]
  def change
    create_table :band_recruitments do |t|
      t.references :user, null: false, foreign_key: true
      # チーム名
      t.string :team_name
      # 募集タイトル
      t.string :title, null: false
      # 活動志向
      t.integer :activity_style
      # 練習単位
      t.string :practice_frequency_unit
      # 練習回数
      t.integer :practice_frequency_count
      # 練習スタイル
      t.integer :practice_style
      # 楽曲タイプ
      t.integer :music_type
      # ライブ出演希望
      t.boolean :wants_live_performance, default: false
      # 期限
      t.date :deadline, null: false
      # 募集ステータス
      t.integer :status, default: 0
      # 募集コメント
      t.text :comment
      t.timestamps
    end
  end
end
