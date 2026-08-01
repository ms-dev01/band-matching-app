class RecruitmentApplicationsController < ApplicationController
  # ログインしていないと使えないようにする
  before_action :authenticate_user!

  def index
    # 募集ステータスの更新
    BandRecruitment.recruiting.each do |band_recruitment|
      # 募集ステータスの更新
      band_recruitment.update_status!
    end

    # 「相手から」 = 応募のあった自分の募集一覧を表示（同一募集への応募は1つの募集にまとめる）
    @received_applications = BandRecruitment.joins(:recruitment_applications).where(band_recruitments: { user_id: current_user.id }).distinct
    # 「自分から」 = 自分が応募した募集の一覧を取得
    @sent_applications = BandRecruitment.joins(:recruitment_applications).where(recruitment_applications: { user_id: current_user.id })

    if params[:filter] == "received"
        # 募集ステータスをenumの昇順に並び替え、同じ募集ステータス内では募集期限の昇順に並び替え
        @band_recruitments = @received_applications.order(:status, :deadline)
    else # params[:filter] == "sent"
        @band_recruitments = @sent_applications.order(:status, :deadline)
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

    # 募集パートがなければ、エラーメッセージを表示
    unless @band_recruitment.recruitment_parts.exists?(part: @application.application_part)
      redirect_to band_recruitment_path(@band_recruitment), alert: "このパートは募集されていません"
      return
    end

    # 承認するパートが定員に達していたら、エラーメッセージを表示
    if @band_recruitment.part_full?(@application.application_part)
      redirect_to band_recruitment_path(@band_recruitment), alert: "このパートは定員に達しています"
      return
    end

    # DBに値が保存されれば、応募成功表示
    if @application.save
      redirect_to band_recruitment_path(@band_recruitment), notice: "応募しました"
    else
      redirect_to band_recruitment_path(@band_recruitment), alert: "応募に失敗しました"
    end
  end

  def update
    @band_recruitment = BandRecruitment.find(params[:band_recruitment_id])
    @application = @band_recruitment.recruitment_applications.find(params[:id])

    # 応募ステータスの変更
    if params[:status] == "approved"
      # 承認するパートが定員に達していたら、エラーメッセージを表示
      if @band_recruitment.part_full?(@application.application_part)
        redirect_to band_recruitment_path(@band_recruitment), alert: "このパートは定員に達しています"
        return
      end
      if @application.update(status: :approved)
        # 応募パートが定員に達したら、他の応募は見送りにする
        if @band_recruitment.part_full?(@application.application_part)
          @band_recruitment.recruitment_applications.pending.where(application_part: @application.application_part).update_all(status: RecruitmentApplication.statuses[:rejected])
        end
        # 全募集パートが定員に達したら、募集ステータスを変更
        if @band_recruitment.all_parts_full?
          @band_recruitment.update(status: :full)
        end
        redirect_to band_recruitment_path(@band_recruitment), notice: "承認しました"
      else
        redirect_to band_recruitment_path(@band_recruitment), alert: "承認できませんでした"
      end
    elsif params[:status] == "rejected"
      if @application.update(status: :rejected)
        redirect_to band_recruitment_path(@band_recruitment), notice: "見送りました"
      else
        redirect_to band_recruitment_path(@band_recruitment), alert: "見送りできませんでした"
      end
    else
      redirect_to band_recruitment_path(@band_recruitment), alert: "操作できませんでした"
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
