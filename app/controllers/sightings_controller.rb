class SightingsController < ApplicationController
  before_action :set_cat
  before_action :set_sighting, only: [:show, :edit, :update, :destroy]
  before_action :authorize_sighting, only: [:edit, :update, :destroy]

  def new
    @sighting = Sighting.new
  end

  def create
    @sighting = @cat.sightings.build(sighting_params)
    @sighting.user = Current.user
    if @sighting.save
      redirect_to cat_sighting_path(@cat, @sighting), notice: "Sighting logged for #{@cat.name}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @sighting.update(sighting_params)
      redirect_to cat_sighting_path(@cat, @sighting), notice: "Sighting updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sighting = @cat.sightings.find(params[:id])
    unless @sighting.user == Current.user
      redirect_to @cat, alert: "You can only remove your own sightings"
      return
    end
    @sighting.destroy
    redirect_to @cat, notice: "Sighting removed"
  end

  private

  def set_sighting
    @sighting = @cat.sightings.find(params[:id])
  end

  def set_cat
    @cat = Cat.find(params[:cat_id])
  end
  
  def authorize_sighting
    unless @sighting.user == Current.user
      redirect_to cat_sighting_path(@cat, @sighting), alert: "You can only edit your own sightings"
    end
  end

  def sighting_params
    params.require(:sighting).permit(:lat, :lng, :body, :photo)
  end
end