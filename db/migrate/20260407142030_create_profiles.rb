class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      # t.references = このテーブルに外部キーを追加する, :user = 対象のモデル, user_idがnullだと保存しない, user_idが存在しないidだと保存しない
      t.references :user, null: false, foreign_key: true
      # ニックネーム
      t.string :nickname, null: false
      # 性別
      t.integer :gender, null: false
      # 生年月日
      t.date :birth_date, null: false
      # 担当パート
      t.integer :part, null: false
      # 担当年数
      t.integer :experience_year
      # 担当月数
      t.integer :experience_month
      # 活動志向
      t.integer :activity_style
      # 練習スタイル
      t.integer :practice_style
      # 楽曲タイプ
      t.integer :music_type
      # ライブ出演希望
      t.boolean :wants_live_performance, default: false
      # SNSリンク
      t.text :sns_links
      # 自己紹介文
      t.text :bio
      t.timestamps
    end
  end
end
