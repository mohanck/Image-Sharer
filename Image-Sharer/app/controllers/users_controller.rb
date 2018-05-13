class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_permit_params)
    if @user.save
      flash[:success] = "Welcome to Image Sharer, #{@user.name}"
      create_session(@user)
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_permit_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
