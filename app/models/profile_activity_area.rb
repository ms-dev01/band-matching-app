class ProfileActivityArea < ApplicationRecord
  belongs_to :profile
  belongs_to :activity_area

  # バリデーション設定（同じ活動地域の重複登録を防止）
  validates :profile_id, uniqueness: { scope: :activity_area_id }
end
