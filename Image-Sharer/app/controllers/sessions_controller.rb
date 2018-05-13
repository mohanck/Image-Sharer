class SessionsController < ApplicationController
  before_action :check_if_logged_in, only: [:new, :create]
  before_action :check_if_logged_out, only: [:destroy]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      create_session user
      params[:session][:remember_me] == '1' ? remember(user) : forget
      flash[:success] = "Welcome back, #{user.name}"
      redirect_to(session.delete(:redirect_url) || root_path)
    else
      flash.now[:danger] = 'Invalid user/password combination'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    flash[:success] = 'You have successfully logged out'
    redirect_to root_path
  end

  private

  def check_if_logged_in
    redirect_to root_path, flash: { warning: 'You are already logged in' } if logged_in?
  end

  def check_if_logged_out
    redirect_to new_session_path, flash: { warning: 'You need to login first' } unless logged_in?
  end
end
