class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.num6
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "users.create.welcome"
      redirect_to @user
    else
      flash[:danger] = t "users.create.warning"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.update.profile"
      redirect_to @user
    else
      flash[:danger] = t "users.update.profile_warning"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy.delete"
    else
      flash[:danger] = t "users.destroy.delete_warning"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.notfound"
    redirect_to users_url
  end

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
