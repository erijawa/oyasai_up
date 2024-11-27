class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_post, only: %i[ edit update destroy ]

  def index
    @q = Post.ransack(params[:q])
    @posts =  @q.result(distinct: true).published.includes(:user).page(params[:page]).order("created_at desc")
  end

  def new
    @post_form = PostForm.new
    @ingredients_form_count = 3
    @steps_form_count = 3
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post_form = PostForm.new(post_params)
    @ingredients_form_count = @post_form.ingredients_name ? @post_form.ingredients_name.size : 0
    @steps_form_count = @post_form.steps_instruction ? @post_form.steps_instruction.size : 0
    tag_list = params[:post_form][:tag_names]&.split(",")
    post = @post_form.save(tag_list) # 保存成功時に該当の投稿詳細にリダイレクトするため、保存されたpostを取得
    if post
      if post.draft?
        redirect_to post_path(post), notice: t("defaults.flash_message.created", item: "下書き")
      else
        redirect_to post_path(post), notice: t("defaults.flash_message.created", item: Post.model_name.human)
      end
    else
      flash.now[:alert] = t("defaults.flash_message.not_created", item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post_form = PostForm.new(post: @post)
    @ingredients_form_count = [ 3, @post_form.ingredients_name.size ].max
    @steps_form_count = [ 3, @post_form.steps_instruction.size ].max
  end

  def update
    @post_form = PostForm.new(post_params, post: @post)
    @ingredients_form_count = @post_form.ingredients_name ? @post_form.ingredients_name.size : 0
    @steps_form_count = @post_form.steps_instruction ? @post_form.steps_instruction.size : 0
    tag_list = params[:post_form][:tag_names]&.split(",")
    post = @post_form.update(tag_list)
    if post
      if post.draft?
        redirect_to post_path(post), notice: t("defaults.flash_message.edited", item: "下書き")
      else
        redirect_to post_path(post), notice: t("defaults.flash_message.edited", item: Post.model_name.human)
      end
    else
      flash.now[:alert] = t("defaults.flash_message.not_edited", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: t("defaults.flash_message.deleted", item: Post.model_name.human), status: :see_other
  end

  def bookmarks
    @q = current_user.bookmark_posts.ransack(params[:q])
    @bookmark_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  private

  def post_params
    params.require(:post_form).permit(
      :title,
      :description,
      :post_image,
      :post_image_cache,
      :tag_names,
      :mode,
      :status,
      :serving,
      { ingredients_name: [] },
      { ingredients_quantity: [] },
      { steps_instruction: [] }
    ).merge(
      user_id: current_user.id
    )
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
