module Profiles
  class SearchService < ApplicationService
    def initialize(input)
      ## Input: Project or campaign idea
      @input = input
    end

    def call
      return nil if @input.blank?

      ## Save query to database
      QueryWorker.perform_async(@input, revised_input, profiles&.as_json)

      ## Return results
      profiles
    end

    private

    def revised_input
      @revised_input ||= @input.present? ? Profiles::ProfileGeneratorService.call(@input) : nil
    end

    def profiles
      @profiles ||= revised_input.present? ? Profiles::SimilaritySearchService.call(revised_input) : nil
    end
  end
end
