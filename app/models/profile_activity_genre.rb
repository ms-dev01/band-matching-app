class ProfileActivityGenre < ApplicationRecord
  belongs_to :profile
  belongs_to :activity_genre

  # バリデーション設定（同じ活動ジャンルの重複登録を防止）
  validates :activity_genre_id, uniqueness: { scope: :profile_id }
end
