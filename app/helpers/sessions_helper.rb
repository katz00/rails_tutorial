module SessionsHelper

  def log_in(user) #一時ログイン
    session[:user_id] = user.id
  end

  def remember(user) #永続ログイン
    user.remember #rememberはremember_token生成、ハッシュ化しremember_digestカラムに登録
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  #ログインの有無でビューのレイアウトを変える時に使う
  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def store_location #store意味:蓄える
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_friendly_url_or_default(default)
    redirect_to (session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
