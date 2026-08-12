require 'rails_helper'

RSpec.describe BandRecruitment, type: :model do
  # ユーザーの作成
  let!(:user) { create(:user, email: 'test@sample.com') }

  # プロフィールの作成
  let!(:profile) { create(:profile) }

  # 活動ジャンルの作成
  let!(:activity_genres) do
    [
      'J-ROCK',
      'J-POP',
      'ロック',
      'ポップス',
      'オルタナティブ'
    ].map do |name|
      ActivityGenre.create!(
        name: name
    )
    end
  end

  # 前提条件
  context '必須項目が入力されている場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    # be_valid = 保存できる状態であるか確認する
    it '募集を保存できる' do
      expect(band_recruitment).to be_valid
    end
  end

  context 'タイトルが入力されていない場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, title: nil)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    it '募集を保存できない' do
      expect(band_recruitment).not_to be_valid
    end
  end

  context '募集パートが入力されていない場合' do
    # 募集の作成
    let(:band_recruitment) { build(:band_recruitment, user: user, title: nil) }

    it '募集を保存できない' do
      expect(band_recruitment).not_to be_valid
      expect(band_recruitment.errors.messages[:base]).to include('募集パートを1つ以上入力してください')
    end
  end

  context '募集期限が入力されていない場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, deadline: nil)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    it '募集を保存できない' do
      expect(band_recruitment).not_to be_valid
    end
  end

  context 'タイトルが100文字以内の場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, title: 'あ' * 100)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    it '募集を保存できる' do
      expect(band_recruitment).to be_valid
    end
  end

  context 'タイトルが101文字以上の場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, title: 'あ' * 101)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    # be_validを実行することでバリデーションが走り、errorsに内容が入る
    it '募集を保存できない' do
      expect(band_recruitment).not_to be_valid
    end
  end

  context '募集期限が過去の場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, deadline: Date.new(2015, 6, 1))
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    # be_validを実行することでバリデーションが走り、errorsに内容が入る
    it '募集を保存できない' do
      expect(band_recruitment).not_to be_valid
      expect(band_recruitment.errors.messages[:deadline]).to include('は過去日にできません')
    end
  end

  context 'コメントが300文字以内の場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, comment: 'あ' * 300)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    it '募集を保存できる' do
      expect(band_recruitment).to be_valid
    end
  end

  context 'コメントが301文字以上の場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, comment: 'あ' * 301)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end

    # be_validを実行することでバリデーションが走り、errorsに内容が入る
    it '募集を保存できない' do
      expect(band_recruitment).not_to be_valid
    end
  end

  context '活動ジャンルと活動志向と楽曲タイプの一部に一致がある場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, activity_style: :hobby, music_type: :original)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end
    let!(:applicant_profile) { create(:profile, activity_style: :hobby, music_type: :cover) }

    # itが実行される前に必ず走る処理
    before do
      band_recruitment.activity_genres << activity_genres.values_at(0, 1, 2)
      applicant_profile.activity_genres << activity_genres.values_at(1, 2, 3, 4)
    end

    it '募集相性を正しく算出できる' do
      expect(
        band_recruitment.recruitment_compatibility_with(applicant_profile)
      ).to eq(78)
    end
  end

  context '活動ジャンルと活動志向と楽曲タイプに一致がない場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, activity_style: :amateur, music_type: :original)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end
    let!(:applicant_profile) { create(:profile, activity_style: :hobby, music_type: :cover) }

    # itが実行される前に必ず走る処理
    before do
      band_recruitment.activity_genres << activity_genres.values_at(0, 1)
      applicant_profile.activity_genres << activity_genres.values_at(2, 3, 4)
    end

    it '募集相性を30%と算出できる' do
      expect(
        band_recruitment.recruitment_compatibility_with(applicant_profile)
      ).to eq(30)
    end
  end

  context '活動ジャンルと活動志向と楽曲タイプが全て一致する場合' do
    # 募集の作成
    let(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user, activity_style: :amateur, music_type: :cover)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment
    end
    let!(:applicant_profile) { create(:profile, activity_style: :amateur, music_type: :cover) }

    # itが実行される前に必ず走る処理
    before do
      band_recruitment.activity_genres << activity_genres.values_at(0, 1, 2)
      applicant_profile.activity_genres << activity_genres.values_at(0, 1, 2)
    end

    it '募集相性を100%と算出できる' do
      expect(
        band_recruitment.recruitment_compatibility_with(applicant_profile)
      ).to eq(100)
    end
  end
end
