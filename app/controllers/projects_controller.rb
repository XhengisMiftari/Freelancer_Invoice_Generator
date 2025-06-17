class ProjectsController < ApplicationController

  before_action :set_project, only: [:show, :destroy, :update, :edit]

def index
  @projects = current_user.projects.includes(:client)
  @project = Project.new
end

  def show
    @projects = current_user.projects.order(:created_at)
  end

  def list
    @projects = current_user.projects.order(created_at: :desc).includes(:client)
    render partial: "projects/list_frame", locals: { projects: @projects }, layout: false
  end

  def create
    @project = Project.new(project_params)
    @project.price = @project.price * 100
    # @project.user = current_user
    if @project.save
      render partial: "projects/new_project_frame", locals: { project: Project.new }, layout: false, status: :created
    else
      render partial: "projects/new_project_frame", locals: { project: @project }, layout: false, status: :unprocessable_entity
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
