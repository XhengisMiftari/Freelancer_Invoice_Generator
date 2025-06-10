class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
    @invoice = Invoice.new

  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to invoices_path, status: :see_other
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
    redirect_to invoice_path(@invoice)
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:description, :project_id, :tax)
  end
end
