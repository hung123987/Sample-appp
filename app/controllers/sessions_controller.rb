class SessionsController < ApplicationController
  before_action :load_params, only: :create

  def new; end

  def create
    if @user&.authenticate @session[:password]
      if @user.activated?
        log_in @user
        session[:remember_me] == Settings.n1 ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = t "account_not_activated"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "users.create.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def load_params
    @session = params[:session]
    @user = User.find_by email: @session[:email].downcase
    return if @user

    flash.now[:danger] = t "users.create.invalid"
    render :new
  end
end
