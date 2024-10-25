class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    @posts = Post.all
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new(post_params)
    if @post_form.valid?
      @post_form.save
      redirect_to :posts, notice: 'おやさいReportを投稿しました。'
    else
      flash.now[:alert] = "投稿できませんでした。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post_form).permit(
      :title,
      :description,
      :post_image,
      :mode,
      serving: [:serving],
      ingredients: [:name, :quantity],
      steps: [:order, :instruction]
    ).merge(
      user_id: current_user.id
    )
  end
end
