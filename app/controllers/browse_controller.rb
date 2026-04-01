class BrowseController < ApplicationController
  def index
    @zip = params[:zip].presence || Current.user.profile&.zip_code

    if @zip.present?
      @people = Profile.where(zip_code: @zip)
                       .where.not(display_name: "")
                       .includes(:user, photo_attachment: :blob)
                       .limit(20)

      recent_sightings = Sighting.joins(:cat)
                                  .order(created_at: :desc)

      cat_ids_in_zip = recent_sightings.select { |s|
        s.lat.present? && s.lng.present?
      }.group_by(&:cat_id).keys.select { |cat_id|
        last = Sighting.where(cat_id: cat_id).order(created_at: :desc).first
        # Check if last sighting is near zip — we use cat tags or just include all for now
        true
      }

      @cats = Cat.where(id: cat_ids_in_zip)
                 .includes(:sightings, profile_photo_attachment: :blob)
                 .limit(20)

      # Find most recent sighting overall to center map
      @map_center = Sighting.order(created_at: :desc).first
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
      @map_center = nil
    end
  end
end