class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, user.activation_token)
      user.update_attribute(:activate, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in(user)
      flash[:success] = "アカウントを有効化しました"
      redirect_to user_path(user)
    else
      flash[:danger] = "無効な有効化リンクです"
      redirect_to root_url
    end
  end
end
