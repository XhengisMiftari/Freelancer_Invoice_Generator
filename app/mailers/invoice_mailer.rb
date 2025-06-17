class InvoiceMailer < ApplicationMailer
  def send_invoice
    @invoice = params[:invoice]
    @project = @invoice.project
    @stripe_url = params[:stripe_url]
    mail(
      to: @project.client.email, # Make sure client has an email
      subject: "Your Invoice from #{ @project.name }"
    )
  end
end
