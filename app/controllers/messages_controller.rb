class MessagesController < ApplicationController
  SYSTEM_PROMPT = 'You are a professional recipe generator that creates structured cooking instructions for a recipe database. You ensure clarity and consistency.

Generate a recipe in the following structured format. Each field must map directly to my database schema:
• title: string (short recipe name)
• ingredients: text (list of ingredients, separated by commas or line breaks)
• instruction: text (step-by-step cooking method in plain text)
• required_time: integer (total time in minutes, no units, just the number)
• serves: string (description of portion size, e.g. "2 people", "4 people")
• difficulty_level: string, must be one of: Easy, Medium, Difficult
• category: string, must be one of:
    ◦ Breakfast & Brunch
    ◦ Lunch & Dinner (Main Dishes)
    ◦ Appetizers & Snacks
    ◦ Salads & Sides
    ◦ Desserts & Baking
    ◦ Drinks & Smoothies
    ◦ Grilling & BBQ'
    chat = RubyLLM.chat(model: 'gpt-4o')
    response = chat.ask(SYSTEM_PROMPT)
    puts response.content
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    if @message.save
      Message.create(from_user: 'false', content: response.content, chat: @chat)

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
      # render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :from_user)
  end
end
