module HuggingFace
  class ChatService < ApplicationService
    def initialize(user_prompt, system_prompt = nil)
      ## TODO: Use Inference Endpoints API
      @client = HuggingFace::InferenceApi.new(api_token: Rails.application.credentials.hugging_face[:api_token])

      @user_prompt = user_prompt
      @system_prompt = system_prompt
    end
  end
end
