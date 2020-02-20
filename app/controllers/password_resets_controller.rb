class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      reset_token = User.new_token
      @user.update_attribute(:reset_digest, User.digest(reset_token))
      @user.update_attribute(:reset_sent_at, Time.zone.now)
      UserMailer.password_reset(@user).deliver_now
      flash[:info] = "パスワードのリセット手順を記載したメールを送信しました"
      redirect_to root_url
    else
      flash[:danger] ="メールアドレスが間違っています。"
      render 'password_resets/new'
    end
  end

  def edit
  end

  def update
    
  end
end
