badges = [
  {
    name: "Early Backer",
    description: "Supported Cat Tracks during early development",
    icon: ""
  },
  {
    name: "Colony Guardian",
    description: "Caregiver for 5 or more cats",
    icon: "🐱"
  },
  {
    name: "Sighting Scout",
    description: "Logged 10 or more cat sightings",
    icon: "🔭"
  },
  {
    name: "Community Pillar",
    description: "Has 100 or more followers",
    icon: "🏛️"
  },
  {
    name: "Rescue Partner",
    description: "Verified rescue organization",
    icon: "🤝"
  }
]

badges.each do |badge|
  Badge.find_or_create_by(name: badge[:name]) do |b|
    b.description = badge[:description]
    b.icon = badge[:icon]
  end
end

puts "Seeded #{Badge.count} badges"