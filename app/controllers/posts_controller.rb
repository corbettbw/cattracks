class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]

  def index
    @mode = params[:mode] == "following" ? :following : :local

    @posts = if @mode == :following
      followed_ids = Current.user.following.pluck(:id)
      if followed_ids.any?
        Post.where(user_id: followed_ids)
            .where(parent_id: nil)
            .order(created_at: :desc)
      else
        Post.none
      end
    else
      user_zip = Current.user.profile&.zip_code
      if user_zip.present?
        Post.joins(user: :profile)
            .where(profiles: { zip_code: user_zip })
            .where(parent_id: nil)
            .order(created_at: :desc)
      else
        Post.where(parent_id: nil).order(created_at: :desc)
      end
    end
  end

  def show
    @post = Post.find(params[:id])
    @replies = @post.replies.order(created_at: :asc)
    @reply = Post.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.build(post_params)
    @post.post_type ||= :microblog

    if params[:post][:parent_id].present?
      parent = Post.find(params[:post][:parent_id])
      # Cap nesting at 2 levels — if parent is already a reply, attach to its parent instead
      @post.parent_id = parent.parent_id? ? parent.parent_id : parent.id
    end

    if @post.save
      redirect_to root_path, notice: "Posted"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    unless @post.user == Current.user
      redirect_to @post, alert: "You can only delete your own posts"
      return
    end
    parent = @post.parent
    @post.destroy
    if parent
      redirect_to post_path(parent), notice: "Reply deleted"
    else
      redirect_to posts_path, notice: "Post deleted"
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, photos: [])
  end
end