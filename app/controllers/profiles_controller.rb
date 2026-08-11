class ProfilesController < ApplicationController
  # ログインしていないと使えないようにする
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update ]
  before_action :set_profile, only: [ :show, :edit, :update ]
  # 自分以外のプロフィールは編集できないようにする
  before_action :authorize_profile!, only: [ :edit, :update ]

  def show
    # モーダル以外で他人のプロフィールへのアクセスは不可
    unless turbo_frame_request? || @profile.user == current_user
      redirect_to root_path, alert: "権限がありません"
    end

    # どの画面から遷移したか
    @source = params[:source]
    if turbo_frame_request?
      @band_recruitment = BandRecruitment.find(params[:band_recruitment_id])
    end
  end

  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)

    # DBに値が保存されれば、作成された募集ページに飛ぶ
    if @profile.save
      redirect_to profile_path(@profile), notice: "プロフィールを作成しました"
    else
      flash.now[:error] = "プロフィールを作成できませんでした"
      # 同じリクエストのままnew.html.hamlを表示し直す
      # バリデーションエラー（必須項目が空など）のときにHTTPステータスコード422を返す
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # 取得したレコードにform送信時に入力されたparamsを渡して上書き
    @profile.assign_attributes(profile_params)

    if @profile.save
      # プロフィール画面に遷移してflashを表示
      redirect_to profile_path(@profile), notice: "プロフィールを更新しました"
    else
      flash.now[:error] = "プロフィールを更新できませんでした"
      # 同じリクエストのままedit.html.hamlを表示し直す
      # バリデーションエラー（必須項目が空など）のときにHTTPステータスコード422を返す
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def authorize_profile!
    unless @profile.user == current_user
      redirect_to root_path, alert: "権限がありません"
    end
  end

  def profile_params
    # formから送信されるパラメータのうち、許可したパラメータのみ受け取る
    params.require(:profile).permit(
      :avatar,
      :nickname,
      :gender,
      :birth_date,
      :part,
      :experience_year,
      :experience_month,
      :activity_style,
      :practice_style,
      :music_type,
      :wants_live_performance,
      :sns_links,
      :bio,
      activity_genre_ids: [],
      activity_area_ids: [],
      personality_ids: [],
      favorite_band_ids: []
    )
  end
end
