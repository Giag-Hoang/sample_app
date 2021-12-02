class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t("app.controller.users.new.success")
      redirect_to @user
    else
      flash[:danger] = t("app.controller.users.new.danger")
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :birthday,
      :gender
    )
  end
end
