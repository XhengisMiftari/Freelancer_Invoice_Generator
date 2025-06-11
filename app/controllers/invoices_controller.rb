class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
    @invoice = Invoice.new
  end

  def preview
    # Example: render the latest invoice as a PDF preview
    @invoice = Invoice.last
    @project = @invoice.project

    respond_to do |format|
      format.html { render :show }
      format.pdf do
        render pdf: "invoice_preview",
               template: "invoices/show",
               layout: 'pdf'
      end
    end
  end


  def show
    @invoice = Invoice.find(params[:id])
    @project = @invoice.project

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "invoice_#{@invoice.id}",
              template: "invoices/show",
              layout: 'pdf'
      end
    end
  end

  def new
    @invoices = Invoice.new
  end


  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to invoices_path, status: :see_other
  end

  def create
  @invoice = Invoice.new(invoice_params)
  if @invoice.save
    # Send the invoice via mail (implement your mailer)
    InvoiceMailer.with(invoice: @invoice).send_invoice.deliver_later
    flash[:notice] = "Invoice created and sent!"
    redirect_to invoice_path(@invoice)
  else
    flash.now[:alert] = "There was a problem creating the invoice."
    render :new, status: :unprocessable_entity
  end
end

  private

  def invoice_params
    params.require(:invoice).permit(:description, :project_id, :tax)
  end
end
