class BrowseController < ApplicationController
  def index
    @zip = params[:zip].presence || Current.user.profile&.zip_code

    if @zip.present?
      @people = Profile.where(zip_code: @zip)
                       .where.not(display_name: "")
                       .includes(:user, photo_attachment: :blob)
                       .limit(20)

      cat_ids_in_zip = Sighting.where(zip_code: @zip).pluck(:cat_id).uniq

      @cats = Cat.where(id: cat_ids_in_zip)
                 .includes(:sightings, profile_photo_attachment: :blob)
                 .limit(20)

      @map_center = Sighting.where(zip_code: @zip).order(created_at: :desc).first
      @cat_pins = @cats.filter_map do |cat|
        last_sighting = cat.sightings.where(zip_code: @zip).order(created_at: :desc).first
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
      @map_center = nil
    end
  end
end