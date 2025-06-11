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
    client = @invoice.project.client
    invoice_html = render_to_string(
    template: 'invoices/show',
    layout: 'pdf', locals: { invoice: @invoice }
  )
    GmailSender.send_gmail(
      current_user,
      client,
      "Your Invoice from #{@invoice.project.name}",
      "Here is your invoice for project #{@invoice.project.name}.",
      invoice_html
    )
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
