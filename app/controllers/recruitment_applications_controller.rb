class RecruitmentApplicationsController < ApplicationController
  # ログインしていないと使えないようにする
  before_action :authenticate_user!

  def index
    # 「相手から」 = 自分の募集に対する応募一覧を表示
    @received_applications = BandRecruitment.joins(:recruitment_applications).where(band_recruitments: { user_id: current_user.id })
    # 「自分から」 = 自分が応募した募集の一覧を取得
    @sent_applications = BandRecruitment.joins(:recruitment_applications).where(recruitment_applications: { user_id: current_user.id })

    if params[:filter] == "received"
        @band_recruitments = @received_applications
    else # params[:filter] == "sent"
        @band_recruitments = @sent_applications
    end

    @received_applications_count = @received_applications.count
    @sent_applications_count = @sent_applications.count
  end

  def create
    @band_recruitment = BandRecruitment.find(params[:band_recruitment_id])

    @application = current_user.recruitment_applications.build(recruitment_application_params)
    @application.band_recruitment = @band_recruitment
    @application.application_part = current_user.profile.part
    @application.status = "pending"

    # DBに値が保存されれば、応募成功表示
    if @application.save
      redirect_to band_recruitment_path(@band_recruitment), notice: "応募しました"
    else
      redirect_to band_recruitment_path(@band_recruitment), alert: "応募に失敗しました"
    end
  end

  private
  def recruitment_application_params
    # formから送信されるパラメータのうち、許可したパラメータのみ受け取る
    params.require(:recruitment_application).permit(
      :application_comment,
   )
  end
end
