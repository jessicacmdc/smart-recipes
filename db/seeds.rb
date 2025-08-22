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
Recipe.destroy_all
Message.destroy_all
User.destroy_all

puts "Seeding users..."
# Users for Devise must have email and password
users = [
  { username: "Alice", email: "alice@example.com", password: "password" },
  { username: "Bob", email: "bob@example.com", password: "password" },
  { username: "Charlie", email: "charlie@example.com", password: "password" },
  { username: "Recipe Hacker", email: "test@test.com", password: "password" }
]

users.each { |user_data| User.create!(user_data) }
puts "✅ Created #{User.count} users"



puts "Seeding chats..."
chats = [
  { title: "Pancakes", user: User.first, model_id:"gpt-4.1-nano" },
  { title: "Chocolate Cake", user: User.second, model_id:"gpt-4.1-nano" },
  { title: "Spaghetti Carbonara", user: User.third, model_id:"gpt-4.1-nano" },
  { title: "Caesar Salad", user: User.first, model_id:"gpt-4.1-nano" },
  { title: "Apple Pie", user: User.second, model_id:"gpt-4.1-nano" }
]

chats.each { |chat_data| Chat.create!(chat_data) }
puts "✅ Created #{Chat.count} chats"


puts "Seeding recipes..."
recipes = [
  {
    title: "Classic Pancakes",
    ingredients: [
      { item: "Flour", amount: "1 cup" },
      { item: "Milk", amount: "1 cup" },
      { item: "Eggs", amount: "2" },
      { item: "Sugar", amount: "2 tbsp" },
      { item: "Baking Powder", amount: "2 tsp" },
      { item: "Salt", amount: "1/2 tsp" },
      { item: "Butter", amount: "2 tbsp" }
    ],
    instruction: "
      1. In a large bowl, whisk together the flour, sugar, baking powder, and salt.
      2. In another bowl, beat the eggs and then add the milk and melted butter.
      3. Pour the wet ingredients into the dry ingredients and mix until just combined.
      4. Heat a non-stick skillet over medium heat and lightly grease with butter.
      5. Pour 1/4 cup of batter per pancake onto the skillet.
      6. Cook until bubbles form on the surface, then flip and cook until golden brown.
      7. Serve warm with syrup, fruits, or toppings of your choice.",
    category: "Breakfast",
    required_time: 20,
    difficulty_level: "Easy",
    serves: "2",
    user: User.first
  },
  {
    title: "Chocolate Cake",
    ingredients: [
      { item: "Flour", amount: "2 cups" },
      { item: "Cocoa Powder", amount: "1/2 cup" },
      { item: "Sugar", amount: "1.5 cups" },
      { item: "Eggs", amount: "3" },
      { item: "Butter", amount: "1 cup" },
      { item: "Baking Powder", amount: "2 tsp" },
      { item: "Milk", amount: "1 cup" }
    ],
    instruction: "
      1. Preheat oven to 180°C (350°F). Grease and flour a cake pan.
      2. In a bowl, sift together the flour, cocoa powder, and baking powder.
      3. In another bowl, beat butter and sugar until creamy, then add eggs one at a time.
      4. Gradually add dry ingredients to the wet mixture, alternating with milk.
      5. Pour batter into the prepared cake pan.
      6. Bake for 35 minutes or until a toothpick comes out clean.
      7. Allow to cool, then frost or serve as desired.",
    category: "Dessert",
    required_time: 60,
    difficulty_level: "Medium",
    serves: "8",
    user: User.second
  },
  {
    title: "Spaghetti Carbonara",
    ingredients: [
      { item: "Spaghetti", amount: "400g" },
      { item: "Eggs", amount: "3" },
      { item: "Parmesan", amount: "50g" },
      { item: "Pancetta", amount: "150g" },
      { item: "Black Pepper", amount: "to taste" }
    ],
    instruction: "
      1. Cook spaghetti in salted boiling water according to package instructions until al dente.
      2. While pasta cooks, fry pancetta in a pan until crispy.
      3. Beat eggs in a bowl and mix in grated Parmesan and black pepper.
      4. Drain pasta, reserving a little cooking water.
      5. Quickly toss hot pasta with pancetta and remove from heat.
      6. Add egg and Parmesan mixture, stirring quickly to create a creamy sauce.
      7. Adjust consistency with reserved pasta water if needed and serve immediately.",
    category: "Main Dish",
    required_time: 30,
    difficulty_level: "Medium",
    serves: "4",
    user: User.third
  },
  {
    title: "Caesar Salad",
    ingredients: [
      { item: "Romaine Lettuce", amount: "1 head" },
      { item: "Croutons", amount: "1 cup" },
      { item: "Parmesan", amount: "30g" },
      { item: "Caesar Dressing", amount: "3 tbsp" }
    ],
    instruction: "
      1. Wash and chop romaine lettuce into bite-sized pieces.
      2. Place lettuce in a large salad bowl.
      3. Add croutons and grated Parmesan.
      4. Drizzle Caesar dressing over the salad.
      5. Toss gently to coat all ingredients evenly.
      6. Serve immediately as a side dish or light meal.",
    category: "Salad",
    required_time: 15,
    difficulty_level: "Easy",
    serves: "2",
    user: User.first
  },
  {
    title: "Apple Pie",
    ingredients: [
      { item: "Apples", amount: "5" },
      { item: "Sugar", amount: "3/4 cup" },
      { item: "Cinnamon", amount: "1 tsp" },
      { item: "Flour", amount: "2 cups" },
      { item: "Butter", amount: "100g" },
      { item: "Pie Crust", amount: "1" }
    ],
    instruction: "
      1. Preheat oven to 190°C (375°F).
      2. Peel, core, and slice apples.
      3. Mix apples with sugar and cinnamon in a bowl.
      4. Roll out pie crust and place in a pie pan.
      5. Pour apple mixture into the crust.
      6. Dot with small pieces of butter on top.
      7. Cover with second crust if desired, seal edges, and make small slits on top.
      8. Bake for 50 minutes or until golden brown.
      9. Let cool before serving.",
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
  { content: "Hey, do you have a good pancake recipe?", role: "user", chat: Chat.first },
  { content: "Yes! Try adding vanilla extract for extra flavor.", role: "assistant", chat: Chat.first },

  { content: "Your chocolate cake was amazing!", role: "user", chat: Chat.second },
  { content: "Thanks! I can share the recipe if you want.", role: "assistant", chat: Chat.second },

  { content: "Is carbonara difficult to make?", role: "user", chat: Chat.third },
  { content: "Not really, just don’t scramble the eggs!", role: "assistant", chat: Chat.third },

  { content: "Caesar salad is my favorite starter.", role: "user", chat: Chat.fourth },
  { content: "Same here, quick and fresh.", role: "assistant", chat: Chat.fourth },

  { content: "I love apple pie in autumn.", role: "user", chat: Chat.fifth },
  { content: "Yes, especially with a scoop of vanilla ice cream!", role: "assistant", chat: Chat.fifth }
]

messages.each { |msg_data| Message.create!(msg_data) }
puts "✅ Created #{Message.count} messages"
