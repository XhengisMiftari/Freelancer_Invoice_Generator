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
    @balance = current_user.balance
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

def balance
  year  = params[:year]&.to_i || Time.current.year
  month = params[:month]&.to_i || Time.current.month

  # Ensure date range covers entire month — beginning and end of day included
  start_date = Date.new(year, month, 1).beginning_of_day
  end_date   = Date.new(year, month, -1).end_of_day

  # Build full day list for x-axis
  days_in_month = (start_date.to_date..end_date.to_date).to_a
  daily_totals = days_in_month.index_with(0)

  # Strict SQL: qualify the created_at column to avoid ambiguity
  actual_data = current_user.invoices
    .where(status: true)
    .where("invoices.created_at >= ? AND invoices.created_at <= ?", start_date, end_date)
    .group("DATE(invoices.created_at)") # this ensures grouping by calendar day only
    .sum(:price_cents)

  # Replace full date with day number (e.g. 1, 2, ..., 30)
  actual_data_by_day = actual_data.transform_keys { |date| date.day }

  # Merge only day-based values into full calendar
  daily_totals_by_day = daily_totals.transform_keys(&:day)
  daily_totals_by_day.merge!(actual_data_by_day)

  @chart_labels = daily_totals_by_day.keys
  @chart_values = daily_totals_by_day.values.map { |c| c.to_f / 10000 }

  # For the chart header and navigation buttons
  @current_month = Date::MONTHNAMES[month]
  @current_year  = year
  @prev_month = month == 1 ? 12 : month - 1
  @prev_year  = month == 1 ? year - 1 : year
  @next_month = month == 12 ? 1 : month + 1
  @next_year  = month == 12 ? year + 1 : year

  respond_to do |format|
    format.html do
      render partial: "shared/balanceGrid",
             locals: {
               chart_labels: @chart_labels,
               chart_values: @chart_values,
               current_month: @current_month,
               current_year: @current_year,
               prev_month: @prev_month,
               prev_year: @prev_year,
               next_month: @next_month,
               next_year: @next_year
             },
             layout: "dash_frame"
    end
  end
end



end

# For sanity reasons: This renders the initial dashboard with the 3 cards mentioned as empty with the "dash_grid" frame.
# Clicking one of the cards triggers Turbo for /dashboard/ in routes
# Then the 3 methods return only the grid partials in /shared/_invoicesGrid.html.erb and others ...
# Turbo swaps that HTML in that frame without needing to reload the page
