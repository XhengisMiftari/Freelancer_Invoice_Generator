class ProjectsController < ApplicationController

  before_action :set_project, only: [:show, :destroy, :update, :edit]

  def index
    @projects = current_user.projects
    @project = Project.new
    @projects = Project.all.includes(:client)
  end

  def show
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to projects_path, notice: 'Project was created.'
    else
      render :index
    end
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path(@project), notice: "Project updated."
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "project has been removed."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :price, :status, :client_id)
  end
end
