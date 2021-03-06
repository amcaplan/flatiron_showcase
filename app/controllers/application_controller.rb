class ApplicationController < ActionController::Base
  before_action :store_url
  before_action :set_controller_name
  before_action :pick_recent_projects
  before_action :reset_page_specific_js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  private
    def store_url
      session[:previous_url] = request.original_url
    end

    def set_controller_name
      @controller = controller_name.titleize if controller_name != "StaticPagesController"
      @controller_path = "/#{@controller.downcase}"
      if @controller == "Users"
        @controller = "Students"
        @controller_path = "/students"
      end
    end

    def pick_recent_projects
      @recent_projects = Project.last(20).shuffle.take(3)
    end

    def reset_page_specific_js
      @page_specific_javascripts = []
    end
end