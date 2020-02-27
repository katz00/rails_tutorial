class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper

  private

  def logged_in_user #Usersコントローラー,Micropostsコントローラーの両方で使う。元はUsersコントローラーにあった
    unless logged_in?
      #def logged_in?
        #!current_user.nil?
      #end
    store_location  #def store_location(default) #store意味:蓄える.sessionsヘルパーで定義
                      #session[:forwarding_url] = request.original_url if request.get?
                    #end フレンドリーフォワーディングのための布石,ログインしないで行こうとしたurlを覚えさせてからリダイレクトさせる
    flash[:danger] = "Please log in!"
    redirect_to login_url
    end
  end

end
