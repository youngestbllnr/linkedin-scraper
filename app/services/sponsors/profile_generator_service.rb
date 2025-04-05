module Sponsors
  class ProfileGeneratorService < ApplicationService
    def initialize(input)
      ## Input: Project or campaign idea
      @input = input
    end

    def call
      revised_input = OpenAI::ChatService.call(@input, system_prompt)
    end

    private

    def system_prompt
      # TODO : Optimize system prompt
      "You are tasked with developing an ideal sponsor description based on a given project or campaign idea. Your objective is to analyze the concept provided and generate a detailed description outlining the characteristics, preferences, and attributes of the ideal sponsor for this initiative. Your description should offer insights into the type of company or individual that would be most aligned with the project's objectives and values. Write the description in present-tense without using 'would' and 'should'."
    end
  end
end
