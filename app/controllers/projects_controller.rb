class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :images, :upload_image]
  before_action :check_user_authorized, only: [:new, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    @page_name = "All Projects"
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @page_name = @project.display_name
    @other_projects = @project.users.map(&:projects).flatten.
      reject{|project| project == @project}.uniq.shuffle.first(5)
  end

  # GET /projects/new
  def new
    # WORKFLOW:
    # SELECT REPOS FROM GITHUB (EXCLUDE ALREADY ADDED PROJECTS)
    # ENTER INFORMATION ABOUT EACH PROJECT (name, url, descriptions(optional))
    # SUBMIT!

    @github_projects = current_user.repos
    existing_projects = Project.pluck(:github_id).map(&:to_i)
    @github_projects.reject! do |project|
      existing_projects.include?(project.id)
    end

    if params[:projects]
      project_ids = params[:projects].map(&:to_i)
      @select_projects = @github_projects.select do |project|
        project_ids.include?(project.id) 
      end

      @select_projects.map! do |project|
        Project.new(name: project.full_name, github_id: project.id, display_name: project.name)
      end

    end
    
    @project = Project.new
    @page_name = "Add New Projects"
  end

  # GET /projects/1/edit
  def edit
    @page_name = "Edit \"#{@project.display_name}\""
  end

  # POST /projects
  # POST /projects.json
  def create
    # FOR EACH PROJECT, VALIDATE INPUT, AND:
    # 1. GET SCREENSHOT
    # 2. ADD OTHER COLLABORATORS (?)
    # 3. SHOW PROJECT PAGE (redirect)
    @projects = params[:projects].map do |project_hash|
      Project.new(project_params(project_hash))
    end

    #call method to take a screenshot
    @projects.each do |project|
      begin
        project.take_app_screenshot!
      rescue
        project.add_no_screenshot_available_image
      end
    end
    
    projects_saved = @projects.all?(&:save)

    @projects.each do |project|
      client = current_user.github_auth.client
      collaborators = client.collabs(project.name)
      collaborators.each do |collaborator|
        login = collaborator.login
        existing_user = User.find_by(github_login: login)
        if existing_user
          project.users << existing_user
        else
          project.users << User.create_from_hash(collaborator)
        end
      end

    end

    respond_to do |format|
      if projects_saved
        format.html { redirect_to current_user, notice: 'Projects were successfully created.' }
       # format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @projects.map(&:errors).join, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update

    # CHANGE INFORMATION ABOUT A PROJECT (name, url, descriptions(optional))
    project_detail = project_params(params[:project])

    if project_detail[:app_type]
      project_detail[:app_type].each do |app_type|
        if !@project.app_types.pluck(:id).include?(app_type.to_i)
          @project.app_types << AppType.find(app_type)
        end
      end
    end

    respond_to do |format|
      if @project.update(live_app_url: project_detail[:live_app_url], 
                         display_name: project_detail[:display_name],
                         technologies: project_detail[:technologies],
                         brief_description: project_detail[:brief_description],
                         longer_description: project_detail[:longer_description])

        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        #format.json { render action: 'show', status: :ok, location: @project }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def about
    @page_name = "Meet the Flatiron Showcase Developers"
  end

  def images
  end

  def upload_image
    pi = ProjectImage.new
    pi.project = @project
    pi.image = params[:image]
    pi.save!
    
    redirect_to images_project_path(@project)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def check_user_authorized
      if !current_user
        redirect_to root_url, notice: 'Please log in using GitHub first.'
      elsif @project && !@project.users.include?(current_user)
        redirect_to @project, notice: 'You are not authorized to make changes to this project.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params(project)
      project.permit(:name, :github_id, :live_app_url, :display_name, :technologies, :brief_description, :longer_description, app_type: [])
    end
end
