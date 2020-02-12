class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login(user)
      flash[:seccess] ="ログインしました"
      redirect_to user_url(user)
    else
      flash.now[:danger] = "invalid email/password combination"
      render 'sessions/new'
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user =nil
    flash[:notice] = "ログアウトしました"
    redirect_to login_url
  end
end
