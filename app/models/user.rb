class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # UserモデルとProfileモデルを紐付け
  # dependent: :destroy = userが削除された時にプロフィールも削除する
  has_one :profile, dependent: :destroy
end
