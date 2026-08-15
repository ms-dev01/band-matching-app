FactoryBot.define do
  # userというfactoryを作成（Userモデルの設定を読み込み、emailとpasswordに値を入力したダミーデータを作成）
  factory :user do
    # ランダムなメールアドレスを生成
    email { Faker::Internet.email }
    password { 'password' }
  end
end
