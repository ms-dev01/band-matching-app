require 'rails_helper'

RSpec.describe 'BandRecruitments', type: :request do
  # ユーザーの作成
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  # プロフィールの作成
  let!(:profile) { create(:profile, user: user) }
  let!(:other_profile) { create(:profile, user: other_user) }

  describe 'GET /band_recruitments' do
    it '200ステータスが返ってくること' do
      # get = メソッド（パスを指定すると、コントローラーにリクエストを送れる）
      get band_recruitments_path
      # getメソッドを使うとresponseが使える
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /band_recruitments' do
    context 'ログインしていない場合' do
      it '募集は作成されず、ログイン画面に遷移する' do
        band_recruitment_params = attributes_for(:band_recruitment)
        band_recruitment_params[:recruitment_parts_attributes] = [
          {
            part: :vocal,
            max_count: 1
          }
        ]

        expect {
          post band_recruitments_path, params: {
            band_recruitment: band_recruitment_params
          }
        }.not_to change(BandRecruitment, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインしている場合' do
      before do
        # ログインする
        sign_in user
      end

      it '募集が保存される' do
        band_recruitment_params = attributes_for(:band_recruitment)
        band_recruitment_params[:recruitment_parts_attributes] = [
          {
            part: :vocal,
            max_count: 1
          }
        ]

        expect {
          post band_recruitments_path, params: {
            band_recruitment: band_recruitment_params
          }
        }.to change(BandRecruitment, :count).by(1)

        expect(response).to have_http_status(302)

        band_recruitment = BandRecruitment.last
        # 保存されたかどうか確認する（一番最後に保存されている募集とband_recruitment_paramsのtitleとdeadlineが一致していれば保存されていると判断）
        expect(band_recruitment.title).to eq(band_recruitment_params[:title])
        expect(band_recruitment.deadline).to eq(band_recruitment_params[:deadline])
        expect(band_recruitment.recruitment_parts.first.part).to eq('vocal')
      end
    end
  end

  describe 'PATCH /band_recruitments/:id' do
    context '自分の募集の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      # 募集の更新
      let(:band_recruitment_params) do
        attributes_for(:band_recruitment).merge(
          recruitment_parts_attributes: {
            "0" => {
              id: band_recruitment.recruitment_parts.first.id,
              part: :guitar,
              max_count: 1
            }
          }
        )
      end

      it '編集できる' do
        expect {
          patch band_recruitment_path(band_recruitment), params: {
            band_recruitment: band_recruitment_params
          }
        }.not_to change(BandRecruitment, :count)

        expect(response).to have_http_status(302)

        band_recruitment.reload

        # 更新後のDBの値と、PATCHで送った値を比較
        expect(band_recruitment.title).to eq(band_recruitment_params[:title])
        expect(band_recruitment.deadline).to eq(band_recruitment_params[:deadline])
        expect(band_recruitment.recruitment_parts.first.part).to eq('guitar')
      end
    end

    context '他人の募集の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      # 募集の更新
      let(:band_recruitment_params) do
        attributes_for(:band_recruitment).merge(
          recruitment_parts_attributes: {
            "0" => {
              id: band_recruitment.recruitment_parts.first.id,
              part: :guitar,
              max_count: 1
            }
          }
        )
      end

      it '編集できない' do
        original_title = band_recruitment.title
        original_deadline = band_recruitment.deadline
        original_part = band_recruitment.recruitment_parts.first.part

        patch band_recruitment_path(band_recruitment), params: {
          band_recruitment: band_recruitment_params
        }

        expect(response).to redirect_to(band_recruitment_path(band_recruitment))

        band_recruitment.reload

        # 更新後のDBの値と、更新前のDBの値を比較
        expect(band_recruitment.title).to eq(original_title)
        expect(band_recruitment.deadline).to eq(original_deadline)
        expect(band_recruitment.recruitment_parts.first.part).to eq(original_part)
      end
    end
  end

  describe 'DELETE /band_recruitments/:id' do
    context '自分の募集の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '削除できる' do
        expect {
          delete band_recruitment_path(band_recruitment)
        }.to change(BandRecruitment, :count).by(-1)

        expect(response).to have_http_status(303)
      end
    end

    context '他人の募集の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '削除できない' do
        expect {
          delete band_recruitment_path(band_recruitment)
        }.not_to change(BandRecruitment, :count)

        expect(response).to redirect_to(band_recruitment_path(band_recruitment))
      end
    end
  end

  describe 'POST /band_recruitments/:band_recruitment_id/recruitment_applications' do
    context '他人の募集の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '参加希望を送信できる' do
        recruitment_application_params = attributes_for(:recruitment_application)

        expect {
          post band_recruitment_recruitment_applications_path(band_recruitment), params: {
            recruitment_application: recruitment_application_params
          }
        }.to change(RecruitmentApplication, :count).by(1)

        expect(response).to have_http_status(302)

        recruitment_application = RecruitmentApplication.last
        # 保存されたかどうか確認する（一番最後に保存されている応募とrecruitment_application_paramsのapplication_commentが一致していれば保存されていると判断）
        expect(recruitment_application.application_comment).to eq(recruitment_application_params[:application_comment])
        # 一番最後に保存されている応募に紐づく募集と作成した募集が一致しているか
        expect(recruitment_application.band_recruitment).to eq(band_recruitment)
        # 一番最後に保存されている応募のuserとログインユーザーが一致しているか
        expect(recruitment_application.user).to eq(user)
      end
    end

    context '自分の募集の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '参加希望を送信できない' do
        recruitment_application_params = attributes_for(:recruitment_application)

        expect {
          post band_recruitment_recruitment_applications_path(band_recruitment), params: {
            recruitment_application: recruitment_application_params
          }
        }.not_to change(RecruitmentApplication, :count)

        expect(response).to redirect_to band_recruitment_path(band_recruitment)
        expect(flash[:alert]).to eq('自分の募集には参加希望できません')
      end
    end
  end

  describe 'PATCH /band_recruitments/:band_recruitment_id/recruitment_applications/:id' do
    context '募集者の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '応募の承認ができる' do
        expect {
          patch band_recruitment_recruitment_application_path(band_recruitment, recruitment_application), params: {
            status: :approved
          }
        }.not_to change(RecruitmentApplication, :count)

        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('承認しました')

        recruitment_application.reload
        # 更新した応募のステータスが送信したパラメータのステータスと一致しているか
        expect(recruitment_application.status).to eq("approved")
      end
    end

    context '募集者の場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '応募の見送りができる' do
        expect {
          patch band_recruitment_recruitment_application_path(band_recruitment, recruitment_application), params: {
            status: :rejected
          }
        }.not_to change(RecruitmentApplication, :count)

        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('見送りました')

        recruitment_application.reload
        # 更新した応募のステータスが送信したパラメータのステータスと一致しているか
        expect(recruitment_application.status).to eq("rejected")
      end
    end

    context '募集者ではない場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '応募の承認ができない' do
        original_status = recruitment_application.status

        patch band_recruitment_recruitment_application_path(band_recruitment, recruitment_application), params: {
            status: :approved
        }

        expect(response).to redirect_to band_recruitment_path(band_recruitment)
        expect(flash[:alert]).to eq('権限がありません')

        recruitment_application.reload

        # 更新前の応募のステータスと更新後の応募のステータスが一致しているか
        expect(recruitment_application.status).to eq(original_status)
      end
    end

    context '募集者ではない場合' do
      before do
        # ログインする
        sign_in user
      end

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

      it '応募の見送りができない' do
        original_status = recruitment_application.status

        patch band_recruitment_recruitment_application_path(band_recruitment, recruitment_application), params: {
            status: :rejected
        }

        expect(response).to redirect_to band_recruitment_path(band_recruitment)
        expect(flash[:alert]).to eq('権限がありません')

        recruitment_application.reload

        # 更新前の応募のステータスと更新後の応募のステータスが一致しているか
        expect(recruitment_application.status).to eq(original_status)
      end
    end
  end
end
