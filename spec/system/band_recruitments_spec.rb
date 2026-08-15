require 'rails_helper'

RSpec.describe 'BandRecruitments', type: :system do
  # ユーザーの作成
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  # プロフィールの作成
  let!(:profile) { create(:profile, user: user) }
  let!(:other_profile) { create(:profile, user: other_user) }

  context '募集者の場合' do
    it 'ログインして募集を作成し、自分の募集を確認できる' do
      # ログインする
      sign_in user

      # 募集作成画面
      visit new_band_recruitment_path

      fill_in('募集タイトル', with: 'テスト募集')

      # ボーカルの人数を1にする
      max_count = find('#band_recruitment_recruitment_parts_attributes_0_max_count')
      max_count.find('option', text: '1').select_option

      deadline = find('#band_recruitment_deadline')
      # 入力がうまくいかないので、JavaScriptを使って募集期限を直接セット
      page.execute_script(
        "arguments[0].value = '2026-09-01';",
        deadline.native
      )

      # 募集を保存
      click_button('保存')

      # 募集詳細画面
      expect(page).to have_css('.card-title', text: 'テスト募集')
      expect(page).to have_css('.card-deadline', text: '2026-09-01')

      # 募集一覧画面へ
      visit band_recruitments_path
      expect(page).to have_css('.card-title', text: 'テスト募集')

      # 自分の募集一覧画面へ
      visit band_recruitments_path(filter: 'my-band-recruitment')
      expect(page).to have_css('.card-title', text: 'テスト募集')
    end
  end

  context '応募者の場合' do
    # 募集の作成
    let!(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: other_user)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment.save!
      band_recruitment
    end

    it 'ログインして募集詳細から相性表示を確認し、参加希望できる' do
      # ログインする
      sign_in user

      # 募集一覧画面へ
      visit band_recruitments_path

      # 募集詳細画面へ
      click_link band_recruitment.title
      expect(page).to have_current_path(band_recruitment_path(band_recruitment))

      # 募集相性を確認
      expect(page).to have_content('募集相性')
      expect(page).to have_css('.card-recruitment-compatibility')

      # 参加希望する
      find('.js-application-btn', text: '参加希望').click

      textarea = find('#recruitment_application_application_comment')
      textarea.set('テスト応募')

      click_button('送信')

      # 「応募しました」の表示を確認して、送信処理が完了してからDBの値を確認する
      expect(page).to have_content('応募しました')
      expect(page).to have_css('.applied', text: '応募済み')

      application = RecruitmentApplication.find_by(user: user, band_recruitment: band_recruitment)
      expect(application).to be_present
      expect(application.application_comment).to eq('テスト応募')
      expect(application.status).to eq('pending')
      expect(application.application_part).to eq(user.profile.part)
    end
  end

  context '募集者の場合' do
    # 募集の作成
    let!(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment.save!
      band_recruitment
    end

    # 応募の作成
    let!(:recruitment_application) { create(:recruitment_application, user: other_user, band_recruitment: band_recruitment, application_part: :vocal, status: :pending) }

    it 'ログインして応募者プロフィールを確認後、承認できる' do
      # ログインする
      sign_in user

      # 募集一覧画面へ
      visit band_recruitments_path

      # 参加希望一覧-相手から画面へ
      visit recruitment_applications_path(filter: 'received')

      # 募集詳細画面へ
      click_link band_recruitment.title
      expect(page).to have_current_path(band_recruitment_path(band_recruitment, source: 'received'))

      # プロフィール相性を確認
      expect(page).to have_content('相性')
      expect(page).to have_css('.card-profile-compatibility')

      # モーダルを表示
      within(
        '.display-application',
        text: other_user.profile.nickname
      ) do
        find('.magnifying-glass-icon').click
      end
      expect(page).to have_css('.modal-profile')

      # モーダルを閉じる
      modal = find('.modal-container')
      # modal-profileの外側、左側の背景をクリック
      modal.click(x: 10, y: 200)

      expect(page).to have_css('.modal-container', visible: false)

      # 承認する
      accept_confirm('この応募を承認しますか？') do
        find('.btn-third.approved', text: '承認する').click
      end

      # 「承認しました」の表示を確認して、送信処理が完了してからDBの値を確認する
      expect(page).to have_content('承認しました')
      expect(page).to have_css('.display-application-status.approved', text: '承認済み')

      application = RecruitmentApplication.find_by(user: other_user, band_recruitment: band_recruitment)
      expect(application).to be_present
      expect(application.status).to eq('approved')
    end
  end

  context '募集者の場合' do
    # 募集の作成
    let!(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: user)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment.save!
      band_recruitment
    end

    # 応募の作成
    let!(:recruitment_application) { create(:recruitment_application, user: other_user, band_recruitment: band_recruitment, application_part: :vocal, status: :pending) }

    it 'ログインして応募者プロフィールを確認後、見送りできる' do
      # ログインする
      sign_in user

      # 募集一覧画面へ
      visit band_recruitments_path

      # 参加希望一覧-相手から画面へ
      visit recruitment_applications_path(filter: 'received')

      # 募集詳細画面へ
      click_link band_recruitment.title
      expect(page).to have_current_path(band_recruitment_path(band_recruitment, source: 'received'))

      # プロフィール相性を確認
      expect(page).to have_content('相性')
      expect(page).to have_css('.card-profile-compatibility')

      # モーダルを表示
      within(
        '.display-application',
        text: other_user.profile.nickname
      ) do
        find('.magnifying-glass-icon').click
      end
      expect(page).to have_css('.modal-profile')

      # モーダルを閉じる
      modal = find('.modal-container')
      # modal-profileの外側、左側の背景をクリック
      modal.click(x: 10, y: 200)

      expect(page).to have_css('.modal-container', visible: false)

      # 見送る
      accept_confirm('この応募を見送りますか？') do
        find('.btn-third.rejected', text: '見送る').click
      end

      # 「見送りました」の表示を確認して、送信処理が完了してからDBの値を確認する
      expect(page).to have_content('見送りました')
      expect(page).to have_css('.display-application-status.rejected', text: '見送り')

      application = RecruitmentApplication.find_by(user: other_user, band_recruitment: band_recruitment)
      expect(application).to be_present
      expect(application.status).to eq('rejected')
    end
  end

  context '承認待ちの場合' do
    # 募集の作成
    let!(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: other_user)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment.save!
      band_recruitment
    end

    # 応募の作成
    let!(:recruitment_application) { create(:recruitment_application, user: user, band_recruitment: band_recruitment, application_part: :vocal, status: :pending) }

    it '承認待ちと表示される' do
      # ログインする
      sign_in user

      # 募集一覧画面へ
      visit band_recruitments_path

      # 参加希望一覧-自分から画面へ
      visit recruitment_applications_path(filter: 'sent')

      # 応募ステータスを確認
      expect(page).to have_content('承認待ち')
      expect(page).to have_css('.display-my-application-status.pending')
    end
  end

  context '承認された場合' do
    # 募集の作成
    let!(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: other_user)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment.save!
      band_recruitment
    end

    # 承認された応募の作成
    let!(:recruitment_application) { create(:recruitment_application, user: user, band_recruitment: band_recruitment, application_part: :vocal, status: :approved) }

    it '承認と表示される' do
      # ログインする
      sign_in user

      # 募集一覧画面へ
      visit band_recruitments_path

      # 参加希望一覧-自分から画面へ
      visit recruitment_applications_path(filter: 'sent')

      # 応募ステータスを確認
      expect(page).to have_content('承認')
      expect(page).to have_css('.display-my-application-status.approved')
    end
  end

  context '見送られた場合' do
    # 募集の作成
    let!(:band_recruitment) do
      band_recruitment = build(:band_recruitment, user: other_user)
      band_recruitment.recruitment_parts.build(
        part: :vocal,
        max_count: 1
      )
      band_recruitment.save!
      band_recruitment
    end

    # 見送られた応募の作成
    let!(:recruitment_application) { create(:recruitment_application, user: user, band_recruitment: band_recruitment, application_part: :vocal, status: :rejected) }

    it '不成立と表示される' do
      # ログインする
      sign_in user

      # 募集一覧画面へ
      visit band_recruitments_path

      # 参加希望一覧-自分から画面へ
      visit recruitment_applications_path(filter: 'sent')

      # 応募ステータスを確認
      expect(page).to have_content('不成立')
      expect(page).to have_css('.display-my-application-status.rejected')
    end
  end
end
