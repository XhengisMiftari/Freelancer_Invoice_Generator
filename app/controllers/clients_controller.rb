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

  private

  def client_params
    params.require(:client).permit(:first_name, :last_name, :date_of_birth, :address, :phone_number, :company_name, :email)
  end

end
