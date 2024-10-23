class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  # def create
  #   @post = current_user.Post.build(post_params)
  #   if post.save
      
  #   else

  #   end
  # end
end
