class ApplicationController < ActionController::Base
  before_action :store_url
  before_action :set_controller_name

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  private
    def store_url
      session[:previous_url] = request.original_url # FIXME store current URL on every page load
    end

    def set_controller_name
      @controller = controller_name.titleize if controller_name != "StaticPagesController"
      @controller = "Students" if @controller == "Users"
    end
end