class FavoriteBand < ApplicationRecord
  # プロフィールと好きなバンドタグの多対多関係を中間テーブルで管理
  has_many :profile_favorite_bands, dependent: :restrict_with_error
  # 好きなバンドタグに紐づくプロフィールを取得（中間テーブル経由）
  has_many :profiles, through: :profile_favorite_bands

  # バリデーション設定
  validates :name, presence: true, uniqueness: true
end
