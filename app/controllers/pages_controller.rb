class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @invoices = Invoice.all
    if params[:query].present?
    @invoices = @invoices.where("description ILIKE ?", "%#{params[:query]}%")
    end
  end

  def index
    @invoices = Invoice.all
  end
end
