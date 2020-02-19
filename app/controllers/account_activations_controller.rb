class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      #user.update_attribute(:activated, true)
      #user.update_attribute(:activated_at, Time.zone.now)
      #上の二つのupdate以下をまとめて一つのメソッドにしてモデルに書いた。それが下のメソッド
      user.activate #userに対してactivateメソッドを呼ぶ。
      log_in(user)
      flash[:success] = "アカウントを有効化しました"
      redirect_to user_url(user)
    else
      flash[:danger] = "無効な有効化リンクです"
      redirect_to root_url
    end
  end

end
