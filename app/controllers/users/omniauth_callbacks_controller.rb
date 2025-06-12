class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env['omniauth.auth']

    @user = User.where(email: auth.info.email).first_or_initialize do |user|
      user.password = Devise.friendly_token[0, 20]
    end

    @user.google_uid = auth.uid
    @user.google_token = auth.credentials.token
    @user.google_refresh_token = auth.credentials.refresh_token if auth.credentials.refresh_token.present?
    @user.save!

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
  end

  def failure
    redirect_to root_path, alert: "Google authentication failed."
  end
end


# class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
#   def google_oauth2
#     @user = User.from_omniauth(request.env['omniauth.auth'])

#     # Save tokens if needed
#     @user.google_token = request.env['omniauth.auth'].credentials.token
#     @user.google_refresh_token = request.env['omniauth.auth'].credentials.refresh_token if request.env['omniauth.auth'].credentials.refresh_token.present?
#     @user.save!

#     sign_in_and_redirect @user, event: :authentication
#     set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
#   end

#   def failure
#     redirect_to root_path, alert: "Google authentication failed."
#   end
# end
