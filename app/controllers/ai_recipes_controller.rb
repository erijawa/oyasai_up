class AiRecipesController < ApplicationController
  before_action :authenticate_user!, except: %i[ create ]

  protect_from_forgery
  before_action :check_csrf

  def create
    @post = Post.find(params[:post_id])
    @ingredient_names = @post.recipe_ingredients.pluck(:name)
    former_ingredient_name, new_ingredient_name = params[:former_ingredient_name], params[:new_ingredient_name]
    if new_ingredient_name.length > 20 || new_ingredient_name.blank?
      flash.now[:alert] = "20字以内で食材を入力してください"
      render "posts/show", status: :unprocessable_entity
    elsif former_ingredient_name.blank?
      flash.now[:alert] = "置き換える食材を選択してください"
      render "posts/show", status: :unprocessable_entity
    end
    former_ingredients = @post.recipe_ingredients.to_json(only: [ :name, :quantity ])
    @response = JSON.parse(Openai::ApiResponseService.new.call(former_ingredient_name, new_ingredient_name, former_ingredients))
    if @response["title"].include?("食材ではありません")
      flash.now[:alert] = "レシピを作成できませんでした"
      render "posts/show", status: :unprocessable_entity
    end
    @post_form = PostForm.new
  rescue => e
    flash.now[:alert] = "エラーが発生しました"
    render "posts/show", status: :internal_server_error
  end
end
