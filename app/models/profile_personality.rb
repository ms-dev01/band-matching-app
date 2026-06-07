class ProfilePersonality < ApplicationRecord
  belongs_to :profile
  belongs_to :personality

  # バリデーション設定（同じ性格タグの重複登録を防止）
  validates :personality_id, uniqueness: { scope: :profile_id }
end
