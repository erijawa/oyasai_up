class AiRecipesController < ApplicationController
  class CsrfProtectionError < StandardError; end
  before_action :authenticate_user!

  protect_from_forgery
  before_action :check_csrf

  def create
    former_ingredient_name, new_ingredient_name = params[:former_ingredient_name],params[:new_ingredient_name]
    @post = Post.find(params[:post_id])
    former_ingredients = @post.recipe_ingredients.to_json(only: [:name, :quantity])
    former_steps = @post.recipe_steps.to_json(only: [:order, :instruction])
    @response = JSON.parse(Openai::ApiResponseService.new.call(former_ingredient_name, new_ingredient_name,former_ingredients,former_steps))

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
