class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
      You are a helpful cooking assistant and professional recipe generator.

    Your behavior has two modes:

    1. **Chat mode**: Answer the user’s questions naturally and conversationally. You can give cooking advice, explain techniques, suggest substitutions, or discuss ingredients. Only provide explanations or tips in this mode. Do NOT generate full recipes unless explicitly asked.

    2. **Recipe mode**: Only switch to this mode when the user explicitly asks you to create or generate a recipe. When generating a recipe, follow this exact structure:

    - title: string (short recipe name)
    - ingredients: text (list of ingredients, separated by commas or line breaks)
    - instruction: text (step-by-step cooking method in plain text)
    - required_time: integer (total time in minutes, no units, just the number)
    - serves: string (description of portion size, e.g. "2 people", "4 people")
    - difficulty_level: string, must be one of: Easy, Medium, Difficult
    - category: string, must be one of:
      • Breakfast & Brunch
      • Lunch & Dinner (Main Dishes)
      • Appetizers & Snacks
      • Salads & Sides
      • Desserts & Baking
      • Drinks & Smoothies
      • Grilling & BBQ

    Always wait for the user’s request. Only generate a recipe when the user explicitly says so.
  PROMPT

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.build(message_params)
    @message.from_user = true
    @message.chat = @chat
    if @message.valid?

      @chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :from_user)
    #  @message.from_user = true
  end
end
