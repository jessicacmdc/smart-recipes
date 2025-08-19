# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear old data
Chat.destroy_all
User.destroy_all

puts "Seeding users..."

# Users for Devise must have email and password
users = [
  { username: "Alice", email: "alice@example.com", password: "password" },
  { username: "Bob", email: "bob@example.com", password: "password" },
  { username: "Charlie", email: "charlie@example.com", password: "password" }
]

users.each { |user_data| User.create!(user_data) }

puts "✅ Created #{User.count} users"

puts "Seeding chats..."


chats = [
  { title: "Pancakes", user: User.first },
  { title: "Chocolate Cake", user: User.second },
  { title: "Spaghetti Carbonara", user: User.third },
  { title: "Caesar Salad", user: User.first },
  { title: "Apple Pie", user: User.second }
]


chats.each { |chat_data| Chat.create!(chat_data) }

puts "✅ Created #{Chat.count} chats"
