class SightingsController < ApplicationController
  before_action :set_cat

  def new
    @sighting = Sighting.new
  end

  def create
    @sighting = @cat.sightings.build(sighting_params)
    @sighting.user = Current.user
    if @sighting.save
      redirect_to @cat, notice: "Sighting logged for #{@cat.name}"
    else
      render :new, status: :unprocessable_entity
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

  def set_cat
    @cat = Cat.find(params[:cat_id])
  end

  def sighting_params
    params.require(:sighting).permit(:lat, :lng, :body)
  end
end