class InvoicesController < ApplicationController

  def index
    @invoices = current_user.invoices
    @invoice = Invoice.new
  end

  def preview
    # Example: render the latest invoice as a PDF preview
    @invoice = Invoice.last
    @project = @invoice.project
    @user = current_user
    respond_to do |format|
      format.html { render :show }
      format.pdf do
        render pdf: "invoice_preview",
               template: "invoices/test",
               layout: 'pdf'
      end
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
    @project = @invoice.project
    @user = current_user
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "invoice_#{@invoice.id}",
              template: "invoices/test",
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
    project = @invoice.project
    @user = current_user
<<<<<<< HEAD
=======

>>>>>>> 27450c08492ad8d5e13a80db6352a9931821f140
    # Check if project dates are present
    if project.project_date.blank? || project.project_date.start_date.blank? || project.project_date.end_date.blank?
      flash[:alert] = "Start date and end date are missing. Please assign them to the project before creating an invoice."
      redirect_to edit_project_path(project) and return
    end

    if @invoice.save
      client = @invoice.project.client
      invoice_html = render_to_string(
        template: 'invoices/test',
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
