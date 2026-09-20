# ApplicationControllerを継承
class BandRecruitmentsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_band_recruitment, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_owner, only: [ :edit, :update, :destroy ]

  def index
    BandRecruitment.recruiting.each do |band_recruitment|
      # 募集ステータスの更新
      band_recruitment.update_status!
    end

    if user_signed_in?
      if params[:filter] == "my-band-recruitment"
        # 募集ステータスをenumの昇順に並び替え、同じ募集ステータス内では募集期限の昇順に並び替え
        @band_recruitments = current_user.band_recruitments.includes(:recruitment_applications).order(:status, :deadline)
      else
        profile = current_user.profile
        # プロフィールの活動地域が設定されている場合
        if profile.activity_area_ids.present?
          activity_area_ids = profile.activity_area_ids
          # プロフィールの活動地域・パートで募集を絞り込み
          @band_recruitments = BandRecruitment.joins(:recruitment_parts).joins(:recruitment_activity_areas).where(recruitment_parts: { part: profile.part }).where(recruitment_activity_areas: { activity_area_id: activity_area_ids }).distinct.order(:status, :deadline)
        else
          # プロフィールのパートで募集を絞り込み
          @band_recruitments = BandRecruitment.joins(:recruitment_parts).where(recruitment_parts: { part: profile.part }).order(:status, :deadline)
        end
      end
    else
      # ログインしていない場合
      @band_recruitments = BandRecruitment.order(:status, :deadline)
    end

    # リクエストされた形式によって処理を分ける
    respond_to do |format|
      # HTMLならHamlを表示
      format.html
      format.json do
        # JSONで要求されたら、@band_recruitmentsをJSONに変換して返す
        render json: {
          currentUser: {
            signedIn: user_signed_in?
          },
          bandRecruitments: @band_recruitments.map do |band_recruitment|
            {
              id: band_recruitment.id,
              user: {
                userId: band_recruitment.user_id,
                profile: {
                  nickname: band_recruitment.user.profile.nickname,
                  part: I18n.t("ui.parts.short.#{band_recruitment.user.profile.part}"),
                  calculateAge: band_recruitment.user.profile.calculate_age,
                  gender: I18n.t("enums.profile.gender.#{band_recruitment.user.profile.gender}"),
                  avatarImage:
                    if band_recruitment.user.profile.avatar&.attached?
                      url_for(band_recruitment.user.profile.avatar)
                    else
                      helpers.asset_path("default-avatar.png")
                    end
                }
              },
              teamName: band_recruitment.team_name,
              title: band_recruitment.title,
              activityStyle: band_recruitment.activity_style,
              activityStyleLabel: I18n.t("enums.band_recruitment.activity_style.#{band_recruitment.activity_style}"),
              practiceFrequencyUnit: band_recruitment.practice_frequency_unit,
              practiceFrequencyUnitLabel: I18n.t("enums.band_recruitment.practice_frequency_unit.#{band_recruitment.practice_frequency_unit}"),
              practiceFrequencyCount: band_recruitment.practice_frequency_count,
              practiceStyle: band_recruitment.practice_style,
              practiceStyleLabel: I18n.t("enums.band_recruitment.practice_style.#{band_recruitment.practice_style}"),
              musicType: band_recruitment.music_type,
              musicTypeLabel: I18n.t("enums.band_recruitment.music_type.#{band_recruitment.music_type}"),
              wantsLivePerformance: band_recruitment.wants_live_performance,
              deadline: band_recruitment.deadline,
              status: band_recruitment.status,
              statusLabel: I18n.t("enums.band_recruitment.status.#{band_recruitment.status}"),
              comment: band_recruitment.comment,
              recruitmentParts: band_recruitment.recruitment_parts.sort_by { |rp| RecruitmentPart.parts[rp.part] }.map do |rp|
                {
                  id: rp.id,
                  bandRecruitmentId: band_recruitment.id,
                  part: I18n.t("enums.recruitment_part.part.#{rp.part}"),
                  maxCount: rp.max_count,
                  full: band_recruitment.part_full?(rp.part)
                }
              end,
              activityGenres: band_recruitment.activity_genres.map do |activity_genre|
                {
                  id: activity_genre.id,
                  name: activity_genre.name
                }
              end,
              activityAreas: band_recruitment.activity_areas.map do |activity_area|
                {
                  id: activity_area.id,
                  name: activity_area.name
                }
              end,
              isOwner: user_signed_in? && band_recruitment.owner?(current_user),
              hasApprovedApplications: band_recruitment.has_approved_applications?,
              approvedApplicationsCount: band_recruitment.approved_applications_count,
              recruitmentCompatibility: user_signed_in? ? band_recruitment.recruitment_compatibility_with(current_user.profile) : nil
            }
          end
        }
      end
    end
  end

  def show
    # 募集ステータスの更新
    @band_recruitment.update_status!
    # どの画面から募集詳細画面に遷移したか
    @source = params[:source]

    if user_signed_in?
      @application = current_user.recruitment_applications.new
    end
  end

  def new
    @band_recruitment = current_user.band_recruitments.new

    # 募集パートと必要人数の初期値を設定
    RecruitmentPart.parts.keys.each do |part|
      @band_recruitment.recruitment_parts.build(
        part: part
        )
    end
  end

  def create
    @band_recruitment = current_user.band_recruitments.new(band_recruitment_params)
    @band_recruitment.user = current_user

    # DBに値が保存されれば、作成された募集ページに飛ぶ
    if @band_recruitment.save
      redirect_to band_recruitment_path(@band_recruitment, source: "my-band-recruitment"), notice: "作成できました"
    else
      rebuild_parts
      flash.now[:error] = "作成できませんでした"
      # 同じリクエストのままnew.html.hamlを表示し直す
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # 一人でも承認したら、その募集の編集・削除はできない
    if @band_recruitment.recruitment_applications.approved.exists? || @band_recruitment.status == "closed"
      redirect_to band_recruitment_path(@band_recruitment, source: params[:source]), alert: "編集できません"
    end
      rebuild_parts
  end

  def update
    # 空欄の募集パートは削除
    params[:band_recruitment][:recruitment_parts_attributes]&.each_value do |attr|
      if attr[:max_count].blank?
        attr[:_destroy] = "1"
      end
    end

    # 更新できたら、更新した募集詳細画面に飛ぶ
    if @band_recruitment.update(band_recruitment_params)
      redirect_to band_recruitment_path(@band_recruitment, source: "my-band-recruitment"), notice: "更新できました"
    else
      rebuild_parts
      flash.now[:error] = "更新できませんでした"
      # 同じリクエストのままedit.html.hamlを表示し直す
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @band_recruitment.destroy!
    # 削除できたら、募集一覧画面に飛ぶ
    redirect_to root_path, status: :see_other, notice: "削除しました"
  end

  def set_band_recruitment
    @band_recruitment = BandRecruitment.find(params[:id])
  end

  def ensure_owner
    # 本人以外が編集できないように制御
    return if @band_recruitment.user == current_user
      redirect_to band_recruitment_path(@band_recruitment), alert: "権限がありません"
  end

  def rebuild_parts
    # 今ある募集パートを取得（nilを除去）
    existing_parts = @band_recruitment.recruitment_parts.map { |rp| rp.part }.compact

    # 足りない募集パートを補充
    RecruitmentPart.parts.keys.each do |part|
      # もしexisting_partsにpartが含まれていなければそのpartを補充
      unless existing_parts.include?(part)
        @band_recruitment.recruitment_parts.build(part: part)
      end
    end
  end

  private
  def band_recruitment_params
    # formから送信されるパラメータのうち、許可したパラメータのみ受け取る
    params.require(:band_recruitment).permit(
      :team_name,
      :title,
      :activity_style,
      :practice_frequency_unit,
      :practice_frequency_count,
      :practice_style,
      :music_type,
      :wants_live_performance,
      :deadline,
      :comment,
      recruitment_parts_attributes: [ :id, :part, :max_count, :_destroy ],
      activity_area_ids: [],
      activity_genre_ids: []
    )
  end
end
