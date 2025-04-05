module OpenAI
  class ChatService < ApplicationService
    MODEL = 'gpt-3.5-turbo-1106'

    def initialize(user_prompt, system_prompt = nil)
      @client = OpenAI::Client.new
      @user_prompt = user_prompt
      @system_prompt = system_prompt
    end

    def call
      return 'Invalid prompt!' if @user_prompt.blank?

      response = @client.chat(parameters: parameters)

      response.dig('choices', 0, 'message', 'content')
    end

    def parameters
      {
        model: MODEL,
        messages: [system_message, user_message].compact
      }
    end

    def system_message
      return nil if @system_prompt.blank?

      { role: 'system', content: @system_prompt }
    end

    def user_message
      { role: 'user', content: @user_prompt }
    end
  end
end
