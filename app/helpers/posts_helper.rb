module PostsHelper
  def format_post_body(post)
    body = h(post.body)

    # Replace @username with links — single word only
    body = body.gsub(/@(\S+)/) do |match|
      name = $1
      profile = Profile.find_by("lower(display_name) = ?", name.downcase)
      if profile
        link_to match, user_path(profile.user), class: "text-amber-700 hover:underline font-medium"
      else
        match
      end
    end

    # Replace $cat name — match greedily then try progressively shorter strings
    # to find the longest cat name that actually exists
    body = body.gsub(/\$([^@$\n]+)/) do |match|
      raw_name = $1.strip
      cat = nil

      # Try longest match first, then progressively shorter
      words = raw_name.split(" ")
      words.length.downto(1) do |len|
        candidate = words.first(len).join(" ")
        cat = Cat.find_by("lower(name) = ?", candidate.downcase)
        break if cat
      end

      if cat
        link_to "$#{cat.name}", cat_path(cat), class: "text-amber-700 hover:underline font-medium"
      else
        match
      end
    end

    body.html_safe
  end
end