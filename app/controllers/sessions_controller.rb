class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      operation(user)
    else
      flash.now[:danger] = t("app.controllers.sessions.password_error")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
