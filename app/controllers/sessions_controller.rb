class SessionsController < ApplicationController
  skip_before_action :store_url

  def create
    user = Authorization.user_from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to session[:previous_url] || root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end