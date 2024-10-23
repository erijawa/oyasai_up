class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    @posts = Post.all
  end

  def new
    @post_form = PostForm.new
  end

  def create
    @post = PostForm.new(post_params)
    if @post.save
      redirect_to :posts, notice: 'おやさいReportを投稿しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :description, :post_image)
  end
end
