class GuestSessionsController < ApplicationController
  def create
    guest_user = User.find_by!(email: "guest@sample.com")
    sign_in guest_user
    redirect_to root_path
  end
end
