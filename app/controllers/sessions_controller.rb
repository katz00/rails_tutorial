class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user) #session[:user_id] = user.id
      #if params[:session][:remember_me] == '1'
      #  remember(user)
      #else
      #  forget(user)
      #end
      #下の一行は上のコメントと等価
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:seccess] ="ログインしました"
      redirect_to user_url(user)
    else
      flash.now[:danger] = "invalid email/password combination"
      render 'sessions/new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = "ログアウトしました"
    redirect_to root_url
  end
end
