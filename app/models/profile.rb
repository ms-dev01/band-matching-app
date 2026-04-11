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
  validates :nickname, presence: true
end
