class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home

  end

   def dashboard
    @invoices = Invoice.joins(project: :user).where(projects: { user_id: current_user.id })
    # Add any other user-specific data here
  end

end
