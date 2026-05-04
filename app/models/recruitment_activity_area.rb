class RecruitmentActivityArea < ApplicationRecord
  belongs_to :band_recruitment
  belongs_to :activity_area

  # バリデーション設定（同じ活動地域の重複登録を防止）
  validates :band_recruitment_id, uniqueness: { scope: :activity_area_id }
end
