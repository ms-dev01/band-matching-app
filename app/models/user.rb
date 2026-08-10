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
  has_many :applied_band_recruitments, through: :recruitment_applications,
           source: :band_recruitment

  def connected_with?(other_user, band_recruitment)
    # 自分の募集に対してその応募者が承認されているか
    if band_recruitment.user_id == id
      other_user.recruitment_applications.approved.where(band_recruitment_id: band_recruitment.id).exists?
    # 他人の募集に対して自分の応募が承認されているか
    elsif band_recruitment.user_id == other_user.id
      recruitment_applications.approved.where(band_recruitment_id: band_recruitment.id).exists?
    end
  end
end
