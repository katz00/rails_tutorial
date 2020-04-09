class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :followings, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #UserMailer.account_activation(@user).deliver_now
      #上のコードをuserモデルでメソッドにしたそれが下。上下で等価。
      @user.send_activation_email
      flash[:info] = "アカウントを有効にするためにメールをチェックしてください"
      redirect_to root_url
    else
      render 'users/new'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page]).per(30)
  end

  def edit
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to user_url(@user)
    else
      render 'users/edit'
    end
  end

  def index
    #@users = User.page(params[:page]).per(30)
    #有効化されたユーザーのみ表示するように変更,SQLのwhereで条件を与える
    @users = User.where(activated: true).page(params[:page]).per(30)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to root_url
  end

  def followings
    @title = "Followings"
    @user = User.find(params[:id])
    @users = @user.followings.page(params[:page]).per(15)
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(15)
    render 'show_follow'
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #Micropostsコントローラーでも使うようになったのでApplicationコントローラーにお引っ越し
    #def logged_in_user #ログインしてこいdef must_loginでもいいかな
    #  unless logged_in?
    #    #def logged_in?
    #      #!current_user.nil?
    #    #end
    #  store_location  #def store_location(default) #store意味:蓄える.sessionsヘルパーで定義
    #                    #session[:forwarding_url] = request.original_url if request.get?
    #                  #end フレンドリーフォワーディングのための布石,ログインしないで行こうとしたurlを覚えさせてからリダイレクトさせる
    #  flash[:danger] = "Please log in!"
    #  redirect_to login_url
    #  end
    #end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
