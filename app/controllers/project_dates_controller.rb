class ProjectDatesController < ApplicationController
  def index
    @projects = current_user.projects.includes(:client)
    @projects = Project.new
  end

  def create
  end
end
