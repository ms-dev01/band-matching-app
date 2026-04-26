class ProfilesController < ApplicationController
  # ログインしていないと使えないようにする
  before_action :authenticate_user!

  def show
    # ログインユーザのプロフィールを取得
    @profile = current_user.profile
  end

  def edit
    # current_userのプロフィールが存在すれば、そのプロフィールレコードを取得し、そうでなければ空のProfileインスタンスを作成
    @profile = current_user.prepare_profile
  end

  def update
    # current_userのプロフィールが存在すれば、そのプロフィールレコードを取得し、そうでなければ空のProfileインスタンスを作成
    @profile = current_user.prepare_profile

    # 取得したレコードにform送信時に入力されたparamsを渡して上書き
    @profile.assign_attributes(profile_params)

    if @profile.save
      # プロフィール画面に遷移してflashを表示
      redirect_to profile_path, notice: "プロフィールを更新しました"
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
      :icon,
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
      # :favorite_bands,
      :sns_links,
      :bio,
      activity_genre_ids: [],
      activity_area_ids: [],
      personality_ids: []
    )
  end
end
