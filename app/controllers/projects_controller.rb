class ProjectsController < ApplicationController
  def index
   # @projects = current_user.projects.includes(:client)
    @projects = Project.all
    @project = Project.new
  end

  def create
  end
end
