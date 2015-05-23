class Api::MailgunController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate

  # POST /api/mailgun/new_mail
  def new_mail
    render body: '', status: 200
  end

  private

  def authenticate
    render(body: '', status: 401) unless authentication_service.verify
  end

  def authentication_service
    Mailgun::AuthenticationService.new(
      params[:token], params[:timestamp], params[:signature]
    )
  end
end
