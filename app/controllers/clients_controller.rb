class ClientsController < ApplicationController

  before_action :set_client, only: [:show, :update, :edit, :destroy]

  def index
    # @clients = Client.left_outer_joins(:projects).where("projects.user_id = :uid OR projects.id IS NULL", uid: current_user.id).distinct <- This was to fix the dropdown menu showing project-less clients as well as to prevent to see clients form other users
    @clients = current_user.clients
  end

  def show
    @projects = @client.projects.order(created_at: :desc)
  end

  def create
    @client = Client.new(client_params)
    @client.user = current_user
    if @client.save
      render partial: "clients/new_client_frame", locals:  { client: Client.new }, layout:  false, status:  :created
    else
      render partial: "clients/new_client_frame", locals:  { client: @client }, layout:  false, status:  :unprocessable_entity
    end
  end

  def list
    # @clients = Client.left_outer_joins(:projects).where("projects.user_id = :uid OR projects.id IS NULL", uid: current_user.id).distinct.order(:company_name)
    @clients = current_user.clients
    render partial: "clients/list_frame", locals: { clients: @clients }, layout: false
  end

  def new
    @client = Client.new
  end

  def update
    if @client.update(client_params)
      redirect_to client_path(@client), notice: "Client updated."
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Client has been removed."
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :date_of_birth, :address, :phone_number, :company_name, :email)
  end
end
