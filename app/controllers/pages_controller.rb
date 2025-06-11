class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @invoices = Invoice.all
  end
end
