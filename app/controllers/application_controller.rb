class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # ログイン後、プロフィールの必須項目が入力されていなければ、プロフィール編集画面に遷移
  before_action :ensure_profile!

  # ログイン後、プロフィールの必須項目が入力されていなければ、プロフィール編集画面に遷移
  def ensure_profile!
    # ログインしていない場合、何もせず終了
    return unless user_signed_in?

    # プロフィール画面の場合、何もせず終了
    return if controller_name == "profiles"

    # プロフィールの必須項目が入力されていなければ、プロフィール編集画面に遷移
    unless current_user.profile.completed?
      redirect_to edit_profile_path
    end
  end
end
