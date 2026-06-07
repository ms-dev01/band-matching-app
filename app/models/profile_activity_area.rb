class ProfileActivityArea < ApplicationRecord
  belongs_to :profile
  belongs_to :activity_area

  # バリデーション設定（同じ活動地域の重複登録を防止）
  validates :activity_area_id, uniqueness: { scope: :profile_id }
end
