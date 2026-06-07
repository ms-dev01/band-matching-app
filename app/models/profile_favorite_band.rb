class ProfileFavoriteBand < ApplicationRecord
  belongs_to :profile
  belongs_to :favorite_band

  # バリデーション設定（同じ好きなバンドタグの重複登録を防止）
  validates :favorite_band_id, uniqueness: { scope: :profile_id }
end
