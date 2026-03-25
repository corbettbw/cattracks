module SightingsHelper
    def static_map_url(lat, lng, zoom: 15, width: 600, height: 200)
        "https://staticmap.openstreetmap.de/staticmap.php?" \
        "center=#{lat},#{lng}&" \
        "zoom=#{zoom}&" \
        "size=#{width}x#{height}&" \
        "markers=#{lat},#{lng},red-pushpin"
    end
end
