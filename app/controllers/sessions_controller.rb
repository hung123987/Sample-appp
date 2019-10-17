class SessionsController < ApplicationController
  def new; end

  def create
    sessions = params[:session]
    user = User.find_by email: sessions[:email].downcase
    if user&.authenticate(sessions[:password])
      log_in user
      sessions[:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t "users.create.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
