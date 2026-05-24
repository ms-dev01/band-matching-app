class BandRecruitment < ApplicationRecord
  # UserモデルとBandRecruitmentモデルを紐付け
  belongs_to :user
  # 募集と活動ジャンルの多対多関係を中間テーブルで管理
  has_many :recruitment_activity_genres, dependent: :destroy
  # 募集に紐づく活動ジャンルを取得（中間テーブル経由）
  has_many :activity_genres, through: :recruitment_activity_genres
  # 募集と活動地域の多対多関係を中間テーブルで管理
  has_many :recruitment_activity_areas, dependent: :destroy
  # 募集に紐づく活動地域を取得（中間テーブル経由）
  has_many :activity_areas, through: :recruitment_activity_areas
  # 募集と募集パートの1対多関係を管理
  has_many :recruitment_parts, dependent: :destroy
  # 親モデル（募集テーブル）から子モデル（募集_パートテーブル）を一緒に保存できるように設定
  accepts_nested_attributes_for :recruitment_parts,
    # 必要人数がblankまたは0の募集パートは保存しない
    reject_if: ->(attr) { attr["max_count"].blank? }, allow_destroy: true

  # 活動志向のパターンを定義
  enum :activity_style, { hobby: 0, amateur: 1, professional: 2 }
  # 練習頻度のパターンを定義
  enum :practice_frequency_unit, { week: 0, month: 1, year: 2 }
  # 練習スタイルのパターンを定義
  enum :practice_style, { lively: 0, focused: 1, flexible: 2 }
  # 楽曲タイプのパターンを定義
  enum :music_type, { original: 0, cover: 1, session: 2, arranged_cover: 3 }
  # 募集ステータスのパターンを定義
  enum :status, { recruiting: 0, full: 1, closed: 2 }

  # バリデーション設定
  validates :title, presence: true, length: { maximum: 100 }
  validate :at_least_one_part_present
  validates :deadline, presence: true
  validate :deadline_not_past
  validates :comment, length: { maximum: 300 }, allow_blank: true

  # 募集パートは1つ以上入力必須
  def at_least_one_part_present
    if recruitment_parts.all? { |part| part.max_count.blank? }
      errors.add(:base, "募集パートを1つ以上入力してください")
    end
  end

  # 過去の期限指定を制限
  def deadline_not_past
    return if deadline.blank?
    if deadline < Time.zone.today
      errors.add(:deadline, "は過去日にできません")
    end
  end
end
