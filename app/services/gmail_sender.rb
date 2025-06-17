require 'google/apis/gmail_v1'
require 'googleauth'
require 'mail'
require 'base64'

class GmailSender
  def self.send_gmail(user, to, subject, body, pdf_string)
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = Signet::OAuth2::Client.new(
      access_token: user.google_token,
      refresh_token: user.google_refresh_token,
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
    )
    raise ArgumentError, "Recipient email address is missing" if to.blank?
    message = Mail.new do
     to to.email
     from user.email
     subject subject

    html_part do
      content_type 'text/html; charset=UTF-8'
      body body
  end
end


    pdf_content = WickedPdf.new.pdf_from_string(pdf_string)

      message.attachments['test.pdf'] = {
            content_type: 'application/pdf',
            content: pdf_content
          }
    msg_str = message.to_s
    message_object = Google::Apis::GmailV1::Message.new(raw: msg_str)
    service.send_user_message('me', message_object)
  end
end
