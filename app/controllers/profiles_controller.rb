# ApplicationControllerを継承
class ProfilesController < ApplicationController
  # ログインしていないと使えないようにする
  before_action :authenticate_user!

  def edit
    # 空のProfileインスタンスの作成
    @profile = current_user.build_profile
  end
end
