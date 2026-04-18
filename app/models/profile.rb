class Profile < ApplicationRecord
  # UserモデルとProfileモデルを紐付け
  belongs_to :user

  # 性別のパターンを定義
  enum :gender, { male: 0, female: 1, other: 2 }
  # 担当パートのパターンを定義
  enum :part, { vocal: 0, guitar: 1, bass: 2, drums: 3, keyboard: 4 }
  # 活動志向のパターンを定義
  enum :activity_style, { hobby: 0, amateur: 1, professional: 2 }
  # 練習スタイルのパターンを定義
  enum :practice_style, { lively: 0, focused: 1, flexible: 2 }
  # 楽曲タイプのパターンを定義
  enum :music_type, { original: 0, cover: 1, session: 2, arranged_cover: 3 }

  # バリデーション設定
  validates :nickname, presence: true, length: { maximum: 20 }
  validates :gender, presence: true
  validate :valid_age_range
  validates :part, presence: true
  validates :bio, length: { maximum: 300 }

  # 年齢を制限
  def valid_age_range
    if birth_date.blank?
      errors.add(:birth_date, "を入力してください")
      return
    end

    age = calculate_age

    # ユーザーは13歳以上100歳未満であること
    if age < 13
      errors.add(:birth_date, "は13歳以上である必要があります")
    end

    # 13歳未満は登録不可
    if age > 100
      errors.add(:birth_date, "の年齢が不正です")
    end
  end

  # 年齢を計算
  def calculate_age
    # 現在の年から誕生年を引く
    years = Time.zone.now.year - birth_date.year
    # 今日のydayから誕生日のydayを引き、誕生日が過ぎたかどうか計算
    days = Time.zone.now.yday - birth_date.yday

    # daysが負の値であれば、誕生日はまだ来ていないのでyearsを-1する
    if days < 0
      years - 1
    else
      years
    end
  end

  def experience_text
    if experience_year == 0 && experience_month == 0
      "未経験"
    elseif experience_year == 0
      "#{experience_month}ヶ月"
    elseif experience_month == 0
      "#{experience_year}年"
    else
      "#{experience_year}年#{experience_month}ヶ月"
    end
  end

  # プロフィールの必須項目が入力されているかどうか
  def completed?
    nickname.present? && gender.present? && birth_date.present? && part.present?
  end
end
