module Collaborations
  class RecommendationService < ApplicationService
    def initialize(input, collaborators_data = nil)
      ## Input: Project or campaign idea
      @input = input
      @collaborators = collaborators_data
    end

    def call
      OpenAI::ChatService.call(user_prompt, system_prompt)
    end

    private

    def user_prompt
      "Potential Collaborator Profiles: #{collaborators&.as_json} Project/Campaign Idea: #{@input}"
    end

    def system_prompt
      'As a researcher, your objective is to recommend the most suitable collaborators for a project or campaign. You will receive a list of potential collaborator profiles and the project or campaign idea. Your task is to identify all optimal collaborators and provide the rationale based on the given information. ONLY recommend collaborators who fit the project or campaign idea.'
    end

    def collaborators
      @collaborators ||= Collaborations::SearchService.call(@input)
    end
  end
end
