class RecruitmentApplicationsController < ApplicationController
  # ログインしていないと使えないようにする
  before_action :authenticate_user!

  def create
    @band_recruitment = BandRecruitment.find(params[:band_recruitment_id])

    # 自分の募集は応募不可
    if @band_recruitment.user == current_user
      redirect_to band_recruitment_path(@band_recruitment), alert: "自分の募集には応募できません"
      return
    end

    # 応募済みチェック
    if current_user.recruitment_applications.exists?(band_recruitment: @band_recruitment)
      redirect_to band_recruitment_path(@band_recruitment), alert: "既に応募済みです"
      return
    end

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
