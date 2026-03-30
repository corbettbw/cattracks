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
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end