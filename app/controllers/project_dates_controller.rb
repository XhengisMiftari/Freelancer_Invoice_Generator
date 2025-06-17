class ProjectDatesController < ApplicationController
  before_action :set_project_date, only: [:show, :edit, :update, :destroy]

  def index
  year = params[:year]&.to_i || Date.today.year
  start_date = params.fetch(:start_date, Date.today).to_date

  if params[:view] == "year"
    @calendar_year = year
    @project_dates = current_user.project_dates
      .where(start_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
  else
    @project_dates = current_user.project_dates
      .where(start_date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end
  @project_date = ProjectDate.new
end

  def show
    @project = @project_date.project
  end

  def new
    @project_date = ProjectDate.new
  end

  def create
    @project_date = ProjectDate.new(project_date_params)
    if @project_date.save
      redirect_to @project_date, notice: "Project date was successfully created."

    else
      flash.now[:alert] = "There was a problem creating the project date."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project_date.update(project_date_params)
      redirect_to @project_date, notice: "Project date was successfully updated."

    else
      flash.now[:alert] = "There was a problem updating the project date."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @project_date.destroy
    redirect_to project_dates_path, notice: "Project date was successfully deleted."
  end

  private

  def set_project_date
    @project_date = ProjectDate.find(params[:id])
  end

  def project_date_params
    params.require(:project_date).permit(:start_date, :end_date, :project_id)
  end
end
