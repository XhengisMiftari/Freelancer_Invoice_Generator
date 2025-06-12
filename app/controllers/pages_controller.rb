class PagesController < ApplicationController
  before_action :authenticate_user!, only: %i[ home invoices clients projects ]

  def home
<<<<<<< HEAD

  end

   def dashboard
    @invoices = Invoice.joins(project: :user).where(projects: { user_id: current_user.id })
    # Add any other user-specific data here
=======
    @invoices_count = current_user.invoices.count
    @clients_count  = current_user.clients.count
    @projects_count = current_user.projects.count
    @invoices = current_user.invoices.includes(project: :client)
  end

  def invoices
    @invoices = current_user.invoices.includes(project: :client)
    render partial: "shared/invoicesGrid", locals:  { invoices: @invoices }, layout: "dash_frame"
  end

  def clients
    @clients = current_user.clients
    render partial: "shared/clientsGrid", locals:  { clients: @clients }, layout: "dash_frame"
  end

  def projects
    @projects = current_user.projects.includes(:client, :project_date)
    render partial: "shared/projectsGrid", locals:  { projects: @projects }, layout: "dash_frame"
>>>>>>> master
  end

end
