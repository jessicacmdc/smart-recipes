class MessagesController < ApplicationController

  SYSTEM_PROMPT_CHAT = <<~PROMPT

You are a helpful cooking assistant and professional recipe generator.

Answer the user's questions naturally and conversationally. You can give cooking advice, explain techniques, suggest substitutions, or discuss ingredients. Only provide explanations or tips in this mode. Do NOT generate full recipes unless explicitly asked.

- title: string (short recipe name)
- ingredients: text (list of hash with 2 keys (item and amount), separated by commas or line breaks)
- instruction: text (step-by-step cooking method in plain text)
- required_time: integer (total time in minutes, no units, just the number)
- serves: string (description of portion size, e.g. "2 people", "4 people")
- difficulty_level: string, must be one of: Easy, Medium, Difficult
- category: string, must be one of:
  • Breakfast
  • Lunch & Dinner
  • Appetizers & Snacks
  • Salads & Sides
  • Desserts & Baking
  • Drinks & Smoothies
  • Grilling & BBQ

Always wait for the user's request. Only generate a recipe when the user explicitly says so.
PROMPT

SYSTEM_PROMPT_RECIPE_GENERATOR =  <<~PROMPT
You are a professional recipe generator API. I will provide a receipe as a single string, and you need to return in stirctly JSON only. Do respond with markdown or any other text.


Please respond in the following JSON format, filling in the recipe data. for Difficulty and Category, you must choose an option provided:
{
   "title":"",
   "ingredients":[
      {
         "item":"",
         "amount":""
      }
   ],
   "instruction": "",
   "required_time":0,
   "serves":"",
   "difficulty_level":"Easy|Medium|Hard",
   "category":"Breakfast & Brunch|Lunch & Dinner|Appetizers & Snacks|Salads & Sides|Desserts & Baking|Drinks & Smoothies|Grilling & BBQ"
}
PROMPT


  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.role = "user"
    @message.chat = @chat
    if @message.valid?
      @chat.with_instructions(instructions).ask(@message.content)

      @chat.generate_title_from_first_message if @chat.title == "Untitled"

        respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end

    else
      # render "chats/show", status: :unprocessable_entity
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form",
                                                                   locals: { chat: @chat, message: @message })
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  def convert_to_recipe()
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.find(params[:id])
    content = @message.content

    @response = RubyLLM.chat.with_instructions(SYSTEM_PROMPT_RECIPE_GENERATOR).ask(content)

    recipe_hash = JSON.parse(@response.content)

    Recipe.create!(title: recipe_hash["title"],
    ingredients: recipe_hash["ingredients"],
    instruction: recipe_hash["instruction"],
    required_time: recipe_hash["required_time"],
    serves: recipe_hash["serves"],
    difficulty_level: recipe_hash["difficulty_level"],
    category: recipe_hash["category"],
    user_id: @chat.user_id
  )

  redirect_to recipes_path
  end

  private

  def chat_context
    "Here is the context of the chat the user is working on:"
  end

  def instructions
    [SYSTEM_PROMPT_CHAT, chat_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
