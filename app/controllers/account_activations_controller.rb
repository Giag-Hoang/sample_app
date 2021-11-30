class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated && user.authenticated?(:activation, params[:id])
      activated user
      log_in user
      flash[:success] = t("app.controller.account.notification")
      redirect_to user
    else
      flash[:danger] = t("app.controller.account.error")
      redirect_to root_url
    end
  end

  def activated user
    user.update_column :activated, true
    user.update_column :activated_at, Time.zone.now
  end
end
