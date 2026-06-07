class RecruitmentActivityGenre < ApplicationRecord
  belongs_to :band_recruitment
  belongs_to :activity_genre

  # バリデーション設定（同じ活動ジャンルの重複登録を防止）
  validates :activity_genre_id, uniqueness: { scope: :band_recruitment_id }
end
