class ProjectsController < ApplicationController
  def index
  @projects = current_user.projects
  @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user

    if @project.save
      redirect_to projects_path, notice: 'Project was created. Congratulations!'
    else
      render :index
    end
  end

  private

 def project_params
    params.require(:project).permit(:name, :price, :status, :client_id)
  end
end
