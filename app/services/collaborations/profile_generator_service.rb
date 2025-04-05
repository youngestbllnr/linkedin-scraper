module Collaborations
  class ProfileGeneratorService < ApplicationService
    def initialize(input)
      ## Input: Project or campaign idea
      @input = input
    end

    def call
      OpenAI::ChatService.call(@input, system_prompt)
    end

    private

    def system_prompt
      # TODO : Optimize system prompt
      "You are tasked with developing an ideal collaborator description based on a given project or campaign idea. Your objective is to analyze the concept provided and generate a detailed description outlining the characteristics, preferences, and attributes of the ideal collaborator for this initiative. Your description should offer insights into the type of company or individual that would be most aligned with the project's objectives and values. Write the description in present-tense without using 'would' and 'should'. Write the description directly without any meta-text or framing - start with the actual description of the collaborator."
    end
  end
end
