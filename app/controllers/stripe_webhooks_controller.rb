class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: [:receive]

  def receive
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      return head :bad_request
    end

    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      invoice = Invoice.find_by(checkout_session_id: session.id)
      if invoice && !invoice.status
        invoice.update(status: true)
        # Add to user's balance
        user = invoice.project.client.user
        user.increment!(:balance_cents, invoice.price_cents)
      end
    end

    head :ok
  end
end
