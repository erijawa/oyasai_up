class AiRecipesController < ApplicationController
  class CsrfProtectionError < StandardError; end
  before_action :authenticate_user!

  protect_from_forgery
  before_action :check_csrf

  def create
    former_ingredient_name, new_ingredient_name = params[:former_ingredient_name], params[:new_ingredient_name]
    if new_ingredient_name.length > 30 || new_ingredient_name.blank? || former_ingredient_name.blank?
      render "posts/show", status: :unprocessable_entity
    end
    @post = Post.find(params[:post_id])
    former_ingredients = @post.recipe_ingredients.to_json(only: [ :name, :quantity ])
    @response = JSON.parse(Openai::ApiResponseService.new.call(former_ingredient_name, new_ingredient_name, former_ingredients))
    @post_form = PostForm.new
    if @response.include?("999")
      flash.now[:alert] = "食材を入力してください"
      render "posts/show", status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
