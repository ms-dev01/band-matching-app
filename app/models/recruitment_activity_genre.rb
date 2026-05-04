class RecruitmentActivityGenre < ApplicationRecord
  belongs_to :band_recruitment
  belongs_to :activity_genre

  # バリデーション設定（同じ活動ジャンルの重複登録を防止）
  validates :band_recruitment_id, uniqueness: { scope: :activity_genre_id }
end
