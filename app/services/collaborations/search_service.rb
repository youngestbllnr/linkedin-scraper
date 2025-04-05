module Collaborations
  class SearchService < ApplicationService
    def initialize(input)
      ## Input: Project or campaign idea
      @input = input
    end

    def call
      return nil if @input.blank?

      ## Save query to database
      QueryWorker.perform_async(@input, revised_input, collaborators&.as_json)

      ## Return results
      collaborators
    end

    private

    def revised_input
      @revised_input ||= @input.present? ? Collaborations::ProfileGeneratorService.call(@input) : nil
    end

    def classifications
      # Modify if custom classifications is required
      Profiles::SimilaritySearchService::COLLABORATORS_CLASSIFICATIONS
    end

    def collaborators
      @collaborators ||= revised_input.present? ? Profiles::SimilaritySearchService.call(revised_input, classifications) : nil
    end
  end
end
