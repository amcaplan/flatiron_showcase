class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_user_logged_in, only: [:edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    @page_name = "The Amazing Flatiron Students!"
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @page_name = @user.name
  end

  # GET /users/1/edit
  def edit
    # input twitter handle, LinkedIn url
    @page_name = "Editing #{@user.name}"
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    # update twitter handle, LinkedIn url
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @user }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def check_user_logged_in
      if !current_user || current_user != @user
        redirect_to User.find(params[:id]), notice: 'You are not authorized to make changes to this user.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :twitter_handle, :linkedin_url, :github_url, :avatar_url, :bio, :hireable)
    end
end
