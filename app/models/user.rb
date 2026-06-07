class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # UserモデルとProfileモデルを紐付け
  # dependent: :destroy = userが削除された時にプロフィールも削除する
  has_one :profile, dependent: :destroy
  # UserモデルとBandRecruitmentモデルを紐付け
  has_many :band_recruitments, dependent: :destroy
  # ユーザーと参加希望の多対多関係を中間テーブルで管理
  has_many :recruitment_applications, dependent: :destroy
  # ユーザーに紐づく募集を取得（中間テーブル経由）
  has_many :band_recruitments, through: :recruitment_applications

  def prepare_profile
    # profileがあればそれを返し、なければ新しく作る
    profile || build_profile
  end
end
