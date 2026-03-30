class UsersController < ApplicationController
  skip_before_action :require_authentication, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to edit_profile_path, notice: "Welcome! Please complete your profile."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @cats = @user.cats.includes(:profile_photo_attachment)
    @posts = @user.posts
                  .where(post_type: [:microblog, :new_cat])
                  .order(created_at: :desc)
    @tagged_posts = Post.joins(:user_tags)
                        .where(user_tags: { tagged_user: @user.id })
                        .order(created_at: :desc)
    @following = Current.user.following.include?(@user)
    @follower_count = @user.followers.count
    @following_count = @user.following.count
  end

  def follow
    @user = User.find(params[:id])
    unless Current.user == @user
      Current.user.follows.find_or_create_by(followed: @user)
    end
    redirect_to user_path(@user)
  end

  def unfollow
    @user = User.find(params[:id])
    follow = Current.user.follows.find_by(followed_id: @user.id)
    if follow
      follow.destroy
      redirect_to user_path(@user), notice: "Unfollowed #{@user.profile&.display_name}"
    else
      redirect_to user_path(@user), alert: "You weren't following this person"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end