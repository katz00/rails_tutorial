class PasswordResetsController < ApplicationController

before_action :get_user, only: [:edit, :update]
before_action :valid_user, only: [:edit, :update]
before_action :check_expiration, only: [:edit, :update]

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
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'password_resets/edit'
    elsif @user.update_attributes(user_params)
      log_in(@user)
      flash[:success] = "パスワードの再設定が成功しました"
      redirect_to user_url(@user)
    else
      render 'password_resets/edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_expiration #パスワード再設定の有効期限をチェック
    if @user.password_reset_expired? #モデルで定義
      flash[:danger] ="パスワード再設定の有効期限が切れています"
      redirect_to new_password_reset_url
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
