class PagesController < ApplicationController
  before_action :authenticate_user!, only: %i[ home invoices clients projects ]
  def home
    @invoices = current_user.invoices
    if params[:query].present?
    query = "%#{params[:query]}%"
    @invoices = @invoices.joins(project: :project_date).where(
    "invoices.description ILIKE :query OR projects.name ILIKE :query OR CAST(project_dates.start_date AS TEXT) ILIKE :query",
    query: query
  )
    end
    @invoices_count = current_user.invoices.count
    @clients_count  = current_user.clients.count
    @projects_count = current_user.projects.count
  end

  def index
    @invoices = current_user.invoices.includes(project: :client)
  end

def invoices
  @invoices = current_user.invoices.includes(project: :client)
  year = params[:year]&.to_i || Time.current.year

  months = Date::MONTHNAMES.compact
  monthly_totals = months.index_with(0)

  actual_data = current_user.invoices
    .where(created_at: Date.new(year).beginning_of_year..Date.new(year).end_of_year)
    .group_by_month(:created_at, format: "%B", time_zone: "Europe/Berlin")
    .count

  monthly_totals.merge!(actual_data)

  respond_to do |format|
    format.html do
      @chart_labels = monthly_totals.keys
      @chart_values = monthly_totals.values

      render partial: "shared/invoicesGrid",
            locals: { invoices: @invoices, chart_labels: @chart_labels, chart_values: @chart_values },
            layout: "dash_frame"
    end

    format.json do
      render json: {
        year: year,
        labels: monthly_totals.keys,
        values: monthly_totals.values
      }
    end
  end
end
    def clients
      @clients = current_user.clients
      year = params[:year]&.to_i || Time.current.year

      months = Date::MONTHNAMES.compact
      monthly_totals = months.index_with(0)

      actual_data = current_user.clients
        .where(created_at: Date.new(year).beginning_of_year..Date.new(year).end_of_year)
        .group_by_month(:created_at, format: "%B", time_zone: "Europe/Berlin")
        .count

      monthly_totals.merge!(actual_data)

      respond_to do |format|
        format.html do
          @chart_labels = monthly_totals.keys
          @chart_values = monthly_totals.values

          render partial: "shared/clientsGrid",
                locals: { clients: @clients, chart_labels: @chart_labels, chart_values: @chart_values },
                layout: "dash_frame"
        end

        format.json do
          render json: {
            year: year,
            labels: monthly_totals.keys,
            values: monthly_totals.values
          }
        end
      end
    end

def projects
  @projects = current_user.projects.includes(:client, :project_date)
  year = params[:year]&.to_i || Time.current.year

  months = Date::MONTHNAMES.compact
  monthly_totals = months.index_with(0)

  actual_data = current_user.projects
    .where(created_at: Date.new(year).beginning_of_year..Date.new(year).end_of_year)
    .group_by_month(:created_at, format: "%B", time_zone: "Europe/Berlin")
    .count

  monthly_totals.merge!(actual_data)

  respond_to do |format|
    format.html do
      @chart_labels = monthly_totals.keys
      @chart_values = monthly_totals.values

      render partial: "shared/projectsGrid",
            locals: { projects: @projects, chart_labels: @chart_labels, chart_values: @chart_values },
            layout: "dash_frame"
    end

    format.json do
      render json: {
        year: year,
        labels: monthly_totals.keys,
        values: monthly_totals.values
      }
    end
  end
end

end

# For sanity reasons: This renders the initial dashboard with the 3 cards mentioned as empty with the "dash_grid" frame.
# Clicking one of the cards triggers Turbo for /dashboard/ in routes
# Then the 3 methods return only the grid partials in /shared/_invoicesGrid.html.erb and others ...
# Turbo swaps that HTML in that frame without needing to reload the page
