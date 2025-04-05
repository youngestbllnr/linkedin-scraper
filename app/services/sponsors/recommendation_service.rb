module Sponsors
  class RecommendationService < ApplicationService
    def initialize(input, sponsors_data = nil)
      ## Input: Project or campaign idea
      @input = input
      @sponsors = sponsors_data
    end

    def call
      OpenAI::ChatService.call(user_prompt, system_prompt)
    end

    private

    def user_prompt
      "Potential Sponsor Profiles: #{sponsors&.as_json} Project/Campaign Idea: #{@input}"
    end

    def system_prompt
      'As a researcher, your objective is to recommend the most suitable sponsors for a project or campaign. You will receive a list of potential sponsor profiles and the project or campaign idea. Your task is to identify all optimal sponsors and provide the rationale based on the given information. ONLY recommend sponsors who fit the project or campaign idea.'
    end

    def sponsors
      @sponsors ||= Sponsors::SearchService.call(@input)
    end
  end
end
