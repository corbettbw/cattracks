class CatsController < ApplicationController
  before_action :set_cat, only: [:show, :edit, :update, :destroy, :claim, :leave]

  def index
    @cats = Cat.all
    @unclaimed_cats = @cats.unclaimed
    @cats = @cats.where.not(id: @unclaimed_cats)
  end

  def show
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.created_by = Current.user.id
    if @cat.save
      Current.user.care_relationships.create!(cat: @cat, role: "primary")
      redirect_to @cat, notice: "#{@cat.name} has been added"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_cat_editor
  end

  def update
    authorize_cat_editor
    if @cat.update(cat_params)
      redirect_to @cat, notice: "#{@cat.name} updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_cat_editor
    @cat.destroy
    redirect_to cats_path, notice: "Cat profile removed"
  end

  def claim
    if @cat.caregivers.include?(Current.user)
      redirect_to @cat, alert: "You're already a caregiver for #{@cat.name}"
    else
      Current.user.care_relationships.create!(cat: @cat, role: "caregiver")
      redirect_to @cat, notice: "You're now a caregiver for #{@cat.name}!"
    end
  end
  
  def leave
    relationship = Current.user.care_relationships.find_by(cat: @cat)
    if relationship
      relationship.destroy
      redirect_to @cat, notice: "You're no longer a caregiver for #{@cat.name}"
    else
      redirect_to @cat, alert: "You weren't listed as a caregiver for #{@cat.name}"
    end
  end
  private

  def set_cat
    @cat = Cat.find(params[:id])
  end

  def authorize_cat_editor
    unless @cat.caregivers.include?(Current.user) || @cat.created_by == Current.user.id
      redirect_to @cat, alert: "You don't have permission to edit this profile"
    end
  end

  def cat_params
    params.require(:cat).permit(:name, :status, :bio, :profile_photo, pictures: [])
  end
end