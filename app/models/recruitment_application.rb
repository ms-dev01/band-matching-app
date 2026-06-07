class RecruitmentApplication < ApplicationRecord
  belongs_to :user
  belongs_to :band_recruitment

  # 応募パートのパターンを定義
  enum :application_part, { vocal: 0, guitar: 1, bass: 2, drums: 3, keyboard: 4 }
  # 応募ステータスのパターンを定義
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  # バリデーション設定（同じ募集への参加希望の重複登録を防止）
  validates :user_id, uniqueness: { scope: :band_recruitment_id }
end
