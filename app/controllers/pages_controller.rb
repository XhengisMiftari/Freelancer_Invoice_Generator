class PagesController < ApplicationController
  before_action :authenticate_user!, only: %i[ home invoices clients projects ]
  def home
    @invoices = Invoice.all
    if params[:query].present?
    @invoices = @invoices.where("description ILIKE ?", "%#{params[:query]}%")
    end
    @invoices_count = current_user.invoices.count
    @clients_count  = current_user.clients.count
    @projects_count = current_user.projects.count
  end

  def index
    @invoices = Invoice.all
    @invoices = current_user.invoices.includes(project: :client)
  end

  def invoices # Renders the "shared/_invoicesGrid" with the layout "dash_frame" - Turbo-frame with id "dash_grid" - just a wrapper
    @invoices = current_user.invoices.includes(project: :client) # Collects all invoices matching the signed in client
    render partial: "shared/invoicesGrid", locals:  { invoices: @invoices }, layout: "dash_frame"
  end
  def clients   # Renders the "shared/_clientsGrid" with the layout "dash_frame" - Turbo-frame with id "dash_grid" - just a wrapper
    @clients = current_user.clients # shows all clients matching the signed in user
    render partial: "shared/clientsGrid", locals:  { clients: @clients }, layout: "dash_frame"
  end
  def projects  #Renders the "shared/_projectsGrid" with the layout "dash_frame" - Turbo-frame with id "dash_grid" - just a wrapper
    @projects = current_user.projects.includes(:client, :project_date) # shows all projects linked with project_dates
    render partial: "shared/projectsGrid", locals:  { projects: @projects }, layout: "dash_frame"
  end
end

# For sanity reasons: This renders the initial dashboard with the 3 cards mentioned as empty with the "dash_grid" frame.
# Clicking one of the cards triggers Turbo for /dashboard/ in routes
# Then the 3 methods return only the grid partials in /shared/_invoicesGrid.html.erb and others ...
# Turbo swaps that HTML in that frame without needing to reload the page
