class RecruitmentPart < ApplicationRecord
  belongs_to :band_recruitment

  # 募集パートのパターンを定義
  enum :part, { vocal: 0, guitar: 1, bass: 2, drums: 3, keyboard: 4 }

  # 同じパートの重複登録を防止
  validates :part, uniqueness: { scope: :band_recruitment_id }
end
