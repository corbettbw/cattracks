class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip

    if @query.present?
      @people = Profile.where("lower(display_name) LIKE ?", "%#{@query.downcase}%")
                       .includes(:user, photo_attachment: :blob)
                       .limit(20)

      @cats = Cat.where("lower(name) LIKE ?", "%#{@query.downcase}%")
                 .includes(:sightings, profile_photo_attachment: :blob)
                 .limit(20)

      @cat_pins = @cats.filter_map do |cat|
        last_sighting = cat.sightings.order(created_at: :desc).first
        next unless last_sighting
        {
          name: cat.name,
          lat: last_sighting.lat,
          lng: last_sighting.lng,
          url: cat_path(cat)
        }
      end
    else
      @people = []
      @cats = []
      @cat_pins = []
    end
  end
end