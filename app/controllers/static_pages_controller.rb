class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      #ログイン済みの時に呼び出されるのでcurrent_userメソッドが呼ばれているので
      #ログインしたユーザーのレコードが@current_userに格納される
      #そのユーザーのマイクロポストをメモリ上に作ってテンプレート変数@micropostに代入してviewに渡す
      #def current_user
      #  if session[:user_id]
      #    @current_user ||= User.find_by(id: session[:user_id])
      #  elsif cookies.signed[:user_id]
      #    user = User.find_by(id: cookies.signed[:user_id])
      #    if user && user.authenticated?(:remember, cookies[:remember_token])
      #      log_in(user)
      #      @current_user = user
      #    end
      #  end
      #end
    end
  end

  def help
  end

  def about
  end
  
  def contact
    
  end

end
