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

  def prepare_profile
    # profileがあればそれを返し、なければ新しく作る
    profile || build_profile
  end
end
