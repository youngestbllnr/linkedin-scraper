module Profiles
  class SimilaritySearchService < ApplicationService
    METHODS = {
      cosine: 'cosine',
      euclidean: 'euclidean'
    }

    CLASSIFICATIONS = {
      talent: 'Talent',
      investor: 'Investor',
      founder: 'Founder'
    }

    SPONSOR_CLASSIFICATIONS = [
      CLASSIFICATIONS[:founder],
      CLASSIFICATIONS[:investor]
    ]

    def initialize(input, classifications = CLASSIFICATIONS.values, limit = 50, method = METHODS[:cosine])
      @input_embedding = OpenAI::EmbeddingService.call(input)
      @classifications = classifications
      @limit = limit
      @method = method
    end

    def call
      Profile.where(classification: @classifications)
             .nearest_neighbors(:embedding, @input_embedding, distance: @method)
             .first(@limit)
             .map { |profile| profile.slice(:username, :classification, :document) }
    end
  end
end
