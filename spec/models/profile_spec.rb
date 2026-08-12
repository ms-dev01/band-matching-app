require 'rails_helper'

RSpec.describe Profile, type: :model do
  # ユーザーの作成
  let!(:user) { create(:user, email: 'test@sample.com') }
  let!(:other_user) { create(:user, email: 'other@sample.com') }

  # 好きなバンドタグの作成
  let!(:favorite_bands) do
    [
      'ONE OK ROCK',
      'RADWIMPS',
      'BUMP OF CHICKEN',
      'Mr.Children',
      'King Gnu'
    ].map do |name|
      FavoriteBand.create!(
        name: name
    )
    end
  end

  # 性格タグの作成
  let!(:personalities) do
    [
      'フレンドリー',
      '明るい',
      '聞き上手',
      '優しい'
    ].map do |name|
      Personality.create!(
        name: name
    )
    end
  end

  # 前提条件
  context '必須項目が入力されている場合' do
    # プロフィールの作成
    let!(:profile) { create(:profile) }

    # be_valid = 保存できる状態であるか確認する
    it 'プロフィールを保存できる' do
      expect(profile).to be_valid
    end
  end

  context 'ニックネームが入力されていない場合' do
    # プロフィールの作成
    let!(:profile) { build(:profile, user: user, nickname: nil) }

    it 'プロフィールを保存できない' do
      expect(profile).not_to be_valid
    end
  end

  context '性別が入力されていない場合' do
    # プロフィールの作成
    let!(:profile) { build(:profile, user: user, gender: nil) }

    it 'プロフィールを保存できない' do
      expect(profile).not_to be_valid
    end
  end

  context '生年月日が入力されていない場合' do
    # プロフィールの作成
    let!(:profile) { build(:profile, user: user, birth_date: nil) }

    it 'プロフィールを保存できない' do
      expect(profile).not_to be_valid
    end
  end

  context 'パートが入力されていない場合' do
    # プロフィールの作成
    let!(:profile) { build(:profile, user: user, part: nil) }

    it 'プロフィールを保存できない' do
      expect(profile).not_to be_valid
    end
  end

  context '13歳未満の場合' do
    # プロフィールの作成
    let!(:profile) { build(:profile, user: user, birth_date: Date.new(2014, 6, 1)) }

    # be_validを実行することでバリデーションが走り、errorsに内容が入る
    it 'プロフィールを保存できない' do
      expect(profile).not_to be_valid
      expect(profile.errors.messages[:base]).to include('13歳以上の方のみ登録できます')
    end
  end

  context '101歳以上の場合' do
    # プロフィールの作成
    let!(:profile) { build(:profile, user: user, birth_date: Date.new(1925, 6, 1)) }

    # be_validを実行することでバリデーションが走り、errorsに内容が入る
    it 'プロフィールを保存できない' do
      expect(profile).not_to be_valid
      expect(profile.errors.messages[:base]).to include('正しい生年月日を入力してください')
    end
  end

  context '自己紹介文が300文字以内の場合' do
    # プロフィールの作成
    let!(:profile) { create(:profile, user: user, bio: "あ" * 300) }

    it 'プロフィールを保存できる' do
      expect(profile).to be_valid
    end
  end

  context '自己紹介文が301文字以上の場合' do
    # プロフィールの作成
    let!(:profile) { build(:profile, user: user, bio: "あ" * 301) }

    it 'プロフィールを保存できない' do
      expect(profile).not_to be_valid
    end
  end

  context '好きなバンドタグと性格タグの一部に一致がある場合' do
    # プロフィールの作成
    let!(:recruiter_profile) { create(:profile, user: user) }
    let!(:applicant_profile) { create(:profile, user: other_user) }

    # itが実行される前に必ず走る処理
    before do
      recruiter_profile.favorite_bands << favorite_bands.values_at(0, 1, 2)
      applicant_profile.favorite_bands << favorite_bands.values_at(1, 2, 3, 4)
      recruiter_profile.personalities << personalities.values_at(0, 1, 2)
      applicant_profile.personalities << personalities.values_at(0, 3)
    end

    it '人物相性を正しく算出できる' do
      expect(
        recruiter_profile.profile_compatibility_with(applicant_profile)
      ).to eq(79)
    end
  end

  context '好きなバンドタグと性格タグに一致がない場合' do
    # プロフィールの作成
    let!(:recruiter_profile) { create(:profile, user: user) }
    let!(:applicant_profile) { create(:profile, user: other_user) }

    # itが実行される前に必ず走る処理
    before do
      recruiter_profile.favorite_bands << favorite_bands.values_at(0, 1)
      applicant_profile.favorite_bands << favorite_bands.values_at(2, 3)
      recruiter_profile.personalities << personalities.values_at(0)
      applicant_profile.personalities << personalities.values_at(1)
    end

    it '人物相性を30%と算出できる' do
      expect(
        recruiter_profile.profile_compatibility_with(applicant_profile)
      ).to eq(30)
    end
  end

  context '好きなバンドタグと性格タグが全て一致する場合' do
    # プロフィールの作成
    let!(:recruiter_profile) { create(:profile, user: user) }
    let!(:applicant_profile) { create(:profile, user: other_user) }

    # itが実行される前に必ず走る処理
    before do
      recruiter_profile.favorite_bands << favorite_bands.values_at(0, 1, 2)
      applicant_profile.favorite_bands << favorite_bands.values_at(0, 1, 2)
      recruiter_profile.personalities << personalities.values_at(0, 1)
      applicant_profile.personalities << personalities.values_at(0, 1)
    end

    it '人物相性を100%と算出できる' do
      expect(
        recruiter_profile.profile_compatibility_with(applicant_profile)
      ).to eq(100)
    end
  end
end
