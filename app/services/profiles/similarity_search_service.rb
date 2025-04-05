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

    COLLABORATORS_CLASSIFICATIONS = [
      CLASSIFICATIONS[:talent],
      CLASSIFICATIONS[:investors],
      CLASSIFICATIONS[:founder],
    ]

    DEFAULT_THRESHOLDS = {
      METHODS[:cosine] => 0.86,
      METHODS[:euclidean] => 0.5 # To be tested out
    }

    def initialize(input, classifications = CLASSIFICATIONS.values, limit = 50, method = METHODS[:cosine], threshold = nil)
      @input_embedding = OpenAI::EmbeddingService.call(input)
      @classifications = classifications
      @limit = limit
      @method = method
      @threshold = threshold
    end

    def call
      results = Profile.where(classification: @classifications)
                      .nearest_neighbors(:embedding, @input_embedding, distance: @method)
                      .order(neighbor_distance: :asc)
                      .first(@limit)

      results = filter_by_threshold(results)

      results.map { |profile| profile.slice(:username, :classification, :document, :neighbor_distance) }
    end

    private

    def filter_by_threshold(results)
      average_distance = results.map(&:neighbor_distance).sum / results.size

      case @method
      when METHODS[:cosine]
        results.select { |result| result.neighbor_distance <= (@threshold || average_distance) }
      when METHODS[:euclidean]
        results.select { |result| result.neighbor_distance <= (@threshold || average_distance) }
      else
        results
      end
    end
  end
end
