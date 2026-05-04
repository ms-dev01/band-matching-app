class ActivityArea < ApplicationRecord
  # プロフィールと活動地域の多対多関係を中間テーブルで管理
  has_many :profile_activity_areas, dependent: :restrict_with_error
  # 活動地域に紐づくプロフィールを取得（中間テーブル経由）
  has_many :profiles, through: :profile_activity_areas
  # 募集と活動地域の多対多関係を中間テーブルで管理
  has_many :recruitment_activity_areas, dependent: :restrict_with_error
  # 活動地域に紐づく募集を取得（中間テーブル経由）
  has_many :band_recruitments, through: :recruitment_activity_areas

  # バリデーション設定
  validates :name, presence: true, uniqueness: true
end
