class RecruitmentPart < ApplicationRecord
  # 子が更新されたら親のupdated_atも更新する
  belongs_to :band_recruitment, touch: true

  # 募集パートのパターンを定義
  enum :part, { vocal: 0, guitar: 1, bass: 2, drums: 3, keyboard: 4 }

  # 同じパートの重複登録を防止
  validates :part, uniqueness: { scope: :band_recruitment_id }
end
