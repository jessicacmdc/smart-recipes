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
Recipe.destroy_all
Message.destroy_all

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


puts "Seeding recipes..."
recipes = [
  {
    title: "Classic Pancakes",
    ingredients: "Flour, Milk, Eggs, Sugar, Baking Powder, Salt, Butter",
    instruction: "Mix ingredients, pour batter on skillet, cook until golden brown.",
    category: "Breakfast",
    required_time: 20,
    difficulty_level: "Easy",
    serves: "2",
    user: User.first
  },
  {
    title: "Chocolate Cake",
    ingredients: "Flour, Cocoa Powder, Sugar, Eggs, Butter, Baking Powder, Milk",
    instruction: "Mix dry and wet ingredients separately, combine, bake at 180°C for 35 mins.",
    category: "Dessert",
    required_time: 60,
    difficulty_level: "Medium",
    serves: "8",
    user: User.second
  },
  {
    title: "Spaghetti Carbonara",
    ingredients: "Spaghetti, Eggs, Parmesan, Pancetta, Black Pepper",
    instruction: "Cook pasta, fry pancetta, mix with egg-parmesan mixture, toss pasta in.",
    category: "Main Dish",
    required_time: 30,
    difficulty_level: "Medium",
    serves: "4",
    user: User.third
  },
  {
    title: "Caesar Salad",
    ingredients: "Romaine Lettuce, Croutons, Parmesan, Caesar Dressing",
    instruction: "Chop lettuce, toss with croutons and dressing, top with parmesan.",
    category: "Salad",
    required_time: 15,
    difficulty_level: "Easy",
    serves: "2",
    user: User.first
  },
  {
    title: "Apple Pie",
    ingredients: "Apples, Sugar, Cinnamon, Flour, Butter, Pie Crust",
    instruction: "Prepare filling, roll crust, assemble, bake at 190°C for 50 mins.",
    category: "Dessert",
    required_time: 90,
    difficulty_level: "Hard",
    serves: "6",
    user: User.second
  }
]

recipes.each { |recipe_data| Recipe.create!(recipe_data) }
puts "✅ Created #{Recipe.count} recipes"



puts "Seeding messages..."
messages = [
  { content: "Hey, do you have a good pancake recipe?", from_user: true, chat: Chat.first },
  { content: "Yes! Try adding vanilla extract for extra flavor.", from_user: false, chat: Chat.first },

  { content: "Your chocolate cake was amazing!", from_user: true, chat: Chat.second },
  { content: "Thanks! I can share the recipe if you want.", from_user: false, chat: Chat.second },

  { content: "Is carbonara difficult to make?", from_user: true, chat: Chat.third },
  { content: "Not really, just don’t scramble the eggs!", from_user: false, chat: Chat.third },

  { content: "Caesar salad is my favorite starter.", from_user: true, chat: Chat.fourth },
  { content: "Same here, quick and fresh.", from_user: false, chat: Chat.fourth },

  { content: "I love apple pie in autumn.", from_user: true, chat: Chat.fifth },
  { content: "Yes, especially with a scoop of vanilla ice cream!", from_user: false, chat: Chat.fifth }
]

messages.each { |msg_data| Message.create!(msg_data) }
puts "✅ Created #{Message.count} messages"
