class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t("app.controller.users.check")
      redirect_to root_url
    else
      flash[:danger] = t("app.controller.users.danger")
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t("app.controllder.users.delete.update")
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  def destroy
    if @user.destroy
      flash[:success] = t("app.controllder.users.delete")
    else
      flash[:danger] = t("app.controllder.users.delete_fail")
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("app.controllder.users.please")
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    redirect_to(root_url) unless @user == current_user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("app.controller.users.error")
    redirect_to root_url
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
