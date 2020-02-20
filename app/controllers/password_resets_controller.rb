class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest_to_users #user.rbでメソッド化してある
      @user.send_reset_email #user.rbでメソッド化してある
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
