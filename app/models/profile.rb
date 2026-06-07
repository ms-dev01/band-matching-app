class Profile < ApplicationRecord
  # UserモデルとProfileモデルを紐付け
  belongs_to :user
  # Profileモデルに画像添付を追加
  has_one_attached :avatar
  # プロフィールと活動ジャンルの多対多関係を中間テーブルで管理
  has_many :profile_activity_genres, dependent: :destroy
  # プロフィールに紐づく活動ジャンルを取得（中間テーブル経由）
  has_many :activity_genres, through: :profile_activity_genres
  # プロフィールと活動地域の多対多関係を中間テーブルで管理
  has_many :profile_activity_areas, dependent: :destroy
  # プロフィールに紐づく活動地域を取得（中間テーブル経由）
  has_many :activity_areas, through: :profile_activity_areas
  # プロフィールと性格タグの多対多関係を中間テーブルで管理
  has_many :profile_personalities, dependent: :destroy
  # プロフィールに紐づく性格タグを取得（中間テーブル経由）
  has_many :personalities, through: :profile_personalities
  # プロフィールと好きなバンドタグの多対多関係を中間テーブルで管理
  has_many :profile_favorite_bands, dependent: :destroy
  # プロフィールに紐づく好きなバンドタグを取得（中間テーブル経由）
  has_many :favorite_bands, through: :profile_favorite_bands

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
  validates :birth_date, presence: true
  validate :valid_age_range
  validates :part, presence: true
  validates :bio, length: { maximum: 300 }

  # プロフィール画像がアップロードされていればそれを表示、アップロードされていなければデフォルト画像を表示
  def avatar_image
    if avatar&.attached?
      avatar
    else
      "default-avatar.png"
    end
  end

  # 年齢を制限
  def valid_age_range
    return if birth_date.blank?

    age = calculate_age

    # ユーザーは13歳以上100歳未満であること
    if age < 13
      errors.add(:base, "13歳以上の方のみ登録できます")
    end

    # 13歳未満は登録不可
    if age > 100
      errors.add(:base, "正しい生年月日を入力してください")
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

  # 担当パートの経験年数
  def experience_text
    if experience_year.blank? && experience_month.blank?
      "未経験"
    elsif experience_year.blank?
      "#{experience_month}ヶ月"
    elsif experience_month.blank?
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
