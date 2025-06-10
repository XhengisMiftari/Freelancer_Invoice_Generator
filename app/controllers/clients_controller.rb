class ClientsController < ApplicationController

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.user = current_user

    if @client.save
      redirect_to @client, notice: "Client has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

   def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to client_path(@client), notice: "Client update"
    else
      render :edit
    end
  end

  def edit
      @client = Client.find(params[:id])
  end

  private

  def client_params
    params.require(:client).permit(:first_name, :last_name, :date_of_birth, :address, :phone_number, :company_name, :email)
  end
end
