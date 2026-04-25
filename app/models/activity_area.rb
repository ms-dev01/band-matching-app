class ActivityArea < ApplicationRecord
  # バリデーション設定
  validates :name, presence: true, uniqueness: true
end
