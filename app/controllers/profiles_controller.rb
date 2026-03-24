class ProfilesController < ApplicationController
  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Current.user.destroy
    terminate_session
    redirect_to root_path, notice: "Account deleted"
  end

  private

  def set_profile
    @profile = Current.user.profile || Current.user.create_profile
  end

  def profile_params
    params.require(:profile).permit(:display_name, :zip_code, :bio, :photo)
  end
end