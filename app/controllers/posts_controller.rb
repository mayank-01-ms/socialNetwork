class PostsController < ApplicationController
  before_action :authenticate_user!

  # def index
  #   @posts = Post.all()
  # end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    
    post_type = "text"

    if @post.media?
      extension = @post.media.file.extension
      if extension == 'mp4'
        post_type = "video"
      else
        post_type = "image"
      end
    end

    @post.post_type = post_type

    if @post.save
      flash[:notice] = "Post creation successful"
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

    def post_params
      params.require(:post).permit(:text, :media, :type, :is_private)
    end
end
