class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user) #登録時に同時にログイン
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_url(@user)
    else
      render 'users/new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
