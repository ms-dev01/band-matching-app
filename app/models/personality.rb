class Personality < ApplicationRecord
  # プロフィールと性格タグの多対多関係を中間テーブルで管理
  has_many :profile_personalities, dependent: :restrict_with_error
  # 性格タグに紐づくプロフィールを取得（中間テーブル経由）
  has_many :profiles, through: :profile_personalities

  # バリデーション設定
  validates :name, presence: true, uniqueness: true
end
