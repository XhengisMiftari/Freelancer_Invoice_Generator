class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoices = Invoice.find(params[:id])
  end
end
