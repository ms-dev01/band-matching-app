class ActivityGenre < ApplicationRecord
  # プロフィールと活動ジャンルの多対多関係を中間テーブルで管理
  has_many :profile_activity_genres, dependent: :restrict_with_error
  # 活動ジャンルに紐づくプロフィールを取得（中間テーブル経由）
  has_many :profiles, through: :profile_activity_genres
  # 募集と活動ジャンルの多対多関係を中間テーブルで管理
  has_many :recruitment_activity_genres, dependent: :restrict_with_error
  # 活動ジャンルに紐づく募集を取得（中間テーブル経由）
  has_many :band_recruitments, through: :recruitment_activity_genres

  # バリデーション設定
  validates :name, presence: true, uniqueness: true
end
