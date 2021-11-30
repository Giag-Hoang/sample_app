class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      operation(user)
    else
      flash.now[:danger] = t("app.controllers.sessions.password")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end

  private

  def operation user
    if user.activated
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      t("app.controller.sessions.message")
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
