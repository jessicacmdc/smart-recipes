class MessagesController < ApplicationController

  SYSTEM_PROMPT = <<~PROMPT
  
You are a helpful cooking assistant and professional recipe generator.

Your behavior has two modes:

1. **Chat mode**: Answer the user’s questions naturally and conversationally. You can give cooking advice, explain techniques, suggest substitutions, or discuss ingredients. Only provide explanations or tips in this mode. Do NOT generate full recipes unless explicitly asked.

2. **Recipe mode**: Only switch to this mode when the user explicitly asks you to create or generate a recipe. When generating a recipe, follow this exact structure:

- title: string (short recipe name)
- ingredients: text (list of hash with 2 keys (item and amount), separated by commas or line breaks)
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
    # @message = Message.new(message_params)
    @message.role = "user"
    if @message.valid?
      @chat.with_instructions(instructions).ask(@message.content)


    @message = Message.new(message_params)
    @message.chat = @chat
    @message.from_user = true


    if @message.save
      chat = RubyLLM.chat

      response = chat.with_instructions(SYSTEM_PROMPT).ask(messages_content)
      Message.create(from_user: false, content: response.content, chat: @chat)

      redirect_to chat_path(@chat)

      @chat.generate_title_from_first_message if @chat.title == "Untitled"

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end

    else
      render "chats/show", status: :unprocessable_entity
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form",
                                                                   locals: { chat: @chat, message: @message })
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def chat_context
    "Here is the context of the chat the user is working on:"
  end


  def convert_to_recipe()
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.find(params[:id])
    content = @message.content
    ingredients_text = content[/\*\*Ingredients:\*\*\s*\n(.+?)\n\n/m, 1]

    ingredients_array = ingredients_text.split("\n").map do |line|
      line = line.sub(/^\s*-\s*/, "").strip  # remove leading dash and spaces
      if match = line.match(/^([\d\/\s\w]+)\s+(.+)$/)
        { amount: match[1].strip, item: match[2].strip }
      else
        { item: line, amount: "" }  # fallback if no amount detected
      end
    end


    Recipe.create!(title: content.downcase[/\*\*title:\*\*\s*(.+)/, 1],
    ingredients: ingredients_array,
    instruction: content.downcase[/\*\*instructions:\*\*\s*\n(.+?)\n\n/m, 1],
    required_time: content.downcase[/\*\*required time:\*\*\s*(\d+)/, 1].to_i,
    serves: content.downcase[/\*\*serves:\*\*\s*(.+)/, 1],
    difficulty_level: content.downcase[/\*\*difficulty level:\*\*\s*(.+)/, 1],
    category: content.downcase[/\*\*category:\*\*\s*(.+)/, 1],
    user_id: @chat.user_id
  )

  redirect_to recipes_path
  end

  private

  def instructions
    [SYSTEM_PROMPT, chat_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
