class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
   'You are a helpful cooking assistant and professional recipe generator.

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

Always wait for the user’s request. Only generate a recipe when the user explicitly says so.'
 PROMPT

  def create
    @chat = Chat.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat

    @message.role = "user"
    if @message.valid?
      @chat.with_instructions(instructions).ask(@message.content)

      if @chat.title == "Untitled"
        @chat.generate_title_from_first_message
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  def messages_content
    @chat.messages.each do |message|
      message.content
    end
  end

  private

  def chat_context
    "Here is the context of the chat the user is working on:"
  end

  def instructions
    [SYSTEM_PROMPT, chat_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
