class BandRecruitment < ApplicationRecord
  # UserモデルとBandRecruitmentモデルを紐付け
  belongs_to :user

  # 活動志向のパターンを定義
  enum :activity_style, { hobby: 0, amateur: 1, professional: 2 }
  # 練習スタイルのパターンを定義
  enum :practice_style, { lively: 0, focused: 1, flexible: 2 }
  # 楽曲タイプのパターンを定義
  enum :music_type, { original: 0, cover: 1, session: 2, arranged_cover: 3 }
  # 募集ステータスのパターンを定義
  enum :status, { recruiting: 0, full: 1, closed: 2 }

  # バリデーション設定
  validates :title, presence: true, length: { maximum: 100 }
  validates :deadline, presence: true
  validate :deadline_not_past
  validates :comment, length: { maximum: 300 }, allow_blank: true

  # 過去の期限指定を制限
  def deadline_not_past
    return if deadline.blank?
    if deadline < Time.zone.today
      errors.add(:deadline, "は過去日にできません")
    end
  end
end
