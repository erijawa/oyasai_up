class AiRecipesController < ApplicationController
  class CsrfProtectionError < StandardError; end
  before_action :authenticate_user!

  protect_from_forgery
  before_action :check_csrf

  def create
    response = Openai::ApiResponseService.new.call(params[:message])
    render json: { response: response }
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def check_csrf
    # Originが許可されていない場合はエラー
    allowed_origins = ['https://oyasaiup.com', 'https://www.oyasaiup.com', 'http://localhost:3000']
    origin = request.headers['Origin']

    if origin.blank? || allowed_origins.exclude?(origin)
      raise CsrfProtectionError
    end

    # Sec-Fetch-Siteが存在していて許可されていない場合はエラー
    allowed_values = ['same-origin', 'same-site']
    sec_fetch_site = request.headers['Sec-Fetch-Site']

    if sec_fetch_site.present? && allowed_values.exclude?(sec_fetch_site.downcase)
      raise CsrfProtectionError
    end
  end
end
