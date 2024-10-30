class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    @posts = Post.all
  end

  def new
    @post_form = PostForm.new
    @ingredients_form_count = 3
  end

  def create
    @post_form = PostForm.new(post_params)
    tag_list = params[:post_form][:tag_names].split(',')
    if @post_form.save(tag_list)
      redirect_to :posts, notice: 'おやさいReportを投稿しました。'
    else
      flash.now[:alert] = "投稿できませんでした。"
      render :new, status: :unprocessable_entity
    end
  end

  # def edit
  #   @ingredients_form_count = [3, @post_form.ingredients_name.size].max
  # end

  private

  def post_params
    params.require(:post_form).permit(
      :title,
      :description,
      :post_image,
      :tag_names,
      :mode,
      :serving,
      {ingredients_name: []},
      {ingredients_quantity: []},
      {steps_instruction: []}
    ).merge(
      user_id: current_user.id
    )
  end
end
