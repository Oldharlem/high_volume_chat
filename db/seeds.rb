# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Cleaning database..."
Message.delete_all
Membership.delete_all
Group.delete_all
User.delete_all

# Create users
puts "Creating users..."
users = [
  "Alice Johnson",
  "Bob Smith",
  "Charlie Brown",
  "Diana Prince",
  "Edward Norton",
  "Fiona Apple"
].map do |name|
  User.create!(name: name)
end

# Create groups with members and messages
puts "Creating groups with messages..."
groups = [
  "Ruby Developers",
  "JavaScript Enthusiasts",
  "Design Team",
  "Project Alpha"
].map do |name|
  # Create group
  group = Group.create!(name: name)
  
  # Add random members (3-5 users per group)
  group_users = users.sample(rand(3..5))
  
  # First user creates the group
  Membership.create!(
    group: group,
    user: group_users[0],
    invited_by: group_users[0],
    invitation_accepted: true
  )
  
  # Other users are invited by the first user
  group_users[1..].each do |user|
    Membership.create!(
      group: group,
      user: user,
      invited_by: group_users[0],
      invitation_accepted: true
    )
  end
  
  # Create some messages (5-15 per group)
  rand(500..15000).times do
    Message.create!(
      group: group,
      user: group_users.sample,
      body: [
        "Hey everyone! 👋",
        "What do you think about this approach?",
        "I'm working on the new feature now.",
        "Could someone review my PR?",
        "Great work team! 🎉",
        "When is the next meeting?",
        "I found a bug in production.",
        "This looks good to me!",
        "Let's discuss this tomorrow.",
        "Anyone free for a quick call?"
      ].sample
    )
  end
  
  group
end

puts "Seed completed!"
puts "Created:"
puts "- #{User.count} users"
puts "- #{Group.count} groups"
puts "- #{Membership.count} memberships"
puts "- #{Message.count} messages"



