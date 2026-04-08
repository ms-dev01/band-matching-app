class Profile < ApplicationRecord
  # UserモデルとProfileモデルを紐付け
  belongs_to :user

  # バリデーション設定
  validates :nickname, presence: true
end
