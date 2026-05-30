# ApplicationControllerを継承
class BandRecruitmentsController < ApplicationController
  before_action :set_band_recruitment, only: [ :edit, :update ]

  def index
    @band_recruitments = BandRecruitment.all
  end

  def show
    @band_recruitment = BandRecruitment.find(params[:id])
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

    # DBに値が保存されれば、作成された募集ページに飛ぶ
    if @band_recruitment.save
      redirect_to band_recruitment_path(@band_recruitment), notice: "作成できました"
    else
      rebuild_parts
      flash.now[:error] = "作成できませんでした"
      # 同じリクエストのままnew.html.hamlを表示し直す
      render :new, status: :unprocessable_entity
    end
  end

  def edit
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
      redirect_to band_recruitment_path(@band_recruitment), notice: "更新できました"
    else
      rebuild_parts
      flash.now[:error] = "更新できませんでした"
      # 同じリクエストのままedit.html.hamlを表示し直す
      render :edit, status: :unprocessable_entity
    end
  end

  def set_band_recruitment
    @band_recruitment = BandRecruitment.find(params[:id])

    # 本人以外が編集できないように制御
    unless @band_recruitment.user_id == current_user.id
      redirect_to band_recruitment_path(@band_recruitment), alert: "権限がありません"
      return
    end
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
