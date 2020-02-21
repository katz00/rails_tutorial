class PasswordResetsController < ApplicationController

before_action :get_user, only: [:edit, :update]
before_action :valid_user, only: [:edit, :update]

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

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

end
