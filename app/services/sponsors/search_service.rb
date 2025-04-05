module Sponsors
  class SearchService < ApplicationService
    def initialize(input)
      ## Input: Project or campaign idea
      @input = input
    end

    def call
      return nil if @input.blank?

      ## Save query to database
      QueryWorker.perform_async(@input, revised_input, sponsors&.as_json)

      ## Return results
      sponsors
    end

    private

    def revised_input
      @revised_input ||= @input.present? ? Sponsors::ProfileGeneratorService.call(@input) : nil
    end

    def classifications
      Profiles::SimilaritySearchService::SPONSOR_CLASSIFICATIONS
    end

    def sponsors
      @sponsors ||= revised_input.present? ? Profiles::SimilaritySearchService.call(revised_input, classifications) : nil
    end
  end
end
