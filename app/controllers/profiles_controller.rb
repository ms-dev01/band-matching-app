class ProfilesController < ApplicationController
  # ログインしていないと使えないようにする
  before_action :authenticate_user!

  def show
    @profile = Profile.find(params[:id])
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
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

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
