class ProfileFavoriteBand < ApplicationRecord
  belongs_to :profile
  belongs_to :favorite_band

  # バリデーション設定（同じ好きなバンドタグの重複登録を防止）
  validates :profile_id, uniqueness: { scope: :favorite_band_id }
end
