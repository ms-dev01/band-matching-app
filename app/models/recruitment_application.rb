class RecruitmentApplication < ApplicationRecord
  belongs_to :user
  belongs_to :band_recruitment

  # 応募パートのパターンを定義
  enum :application_part, { vocal: 0, guitar: 1, bass: 2, drums: 3, keyboard: 4 }
  # 応募ステータスのパターンを定義
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  # バリデーション設定（同じ募集への参加希望の重複登録を防止）
  validates :user_id, uniqueness: { scope: :band_recruitment_id }
  validate :cannot_apply_own_recruitment

  # 自分の募集は応募不可
  def cannot_apply_own_recruitment
    return unless band_recruitment
    if band_recruitment.user_id == user_id
      errors.add(:base, "自分の募集には応募できません")
    end
  end
end
