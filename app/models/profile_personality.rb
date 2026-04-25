class ProfilePersonality < ApplicationRecord
  belongs_to :profile
  belongs_to :personality

  # バリデーション設定（同じ性格タグの重複登録を防止）
  validates :profile_id, uniqueness: { scope: :personality_id }
end
