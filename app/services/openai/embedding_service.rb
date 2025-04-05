module OpenAI
  class EmbeddingService < ApplicationService
    MODELS = {
      small: 'text-embedding-3-small',
      large: 'text-embedding-3-large',
      ada: 'text-embedding-ada-002'
    }

    def initialize(input, model = MODELS[:small])
      @client = OpenAI::Client.new
      @input = input
      @model = model
    end

    def call
      response = @client.embeddings(parameters: parameters)

      response.dig('data', 0, 'embedding')
    end

    private

    def parameters
      { model: @model, input: @input }
    end
  end
end
