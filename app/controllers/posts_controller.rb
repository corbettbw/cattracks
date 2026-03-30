class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]

  def index
    @mode = params[:mode] == "following" ? :following : :local

    @posts = if @mode == :following
      followed_ids = Current.user.following.pluck(:id)
      if followed_ids.any?
        Post.where(user_id: followed_ids)
            .order(created_at: :desc)
      else
        Post.none
      end
    else
      user_zip = Current.user.profile&.zip_code
      if user_zip.present?
        Post.joins(user: :profile)
            .where(profiles: { zip_code: user_zip })
            .order(created_at: :desc)
      else
        Post.order(created_at: :desc)
      end
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.build(post_params)
    @post.post_type ||= :microblog
    if @post.save
      redirect_to root_path, notice: "Posted"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    unless @post.user == Current.user
      redirect_to @post, alert: "You can only delete your own posts"
      return
    end
    @post.destroy
    redirect_to posts_path, notice: "Post deleted"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, photos: [])
  end
end