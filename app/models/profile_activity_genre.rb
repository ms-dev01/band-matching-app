class ProfileActivityGenre < ApplicationRecord
  belongs_to :profile
  belongs_to :activity_genre

  # バリデーション設定（同じ活動ジャンルの重複登録を防止）
  validates :profile_id, uniqueness: { scope: :activity_genre_id }
end
