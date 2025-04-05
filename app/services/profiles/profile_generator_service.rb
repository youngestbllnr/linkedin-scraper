module Profiles
  class ProfileGeneratorService < ApplicationService
    def initialize(input)
      ## Input: Profile description or keywords
      @input = input
    end

    def call
      OpenAI::ChatService.call(@input, system_prompt)
    end

    private

    def system_prompt
      "You are a profile description enhancer. Your task is to transform brief user inputs into highly specific, focused profile descriptions that will be used for similarity search.

      When given a brief description or keywords, create a precise profile by:
      1. Keeping the description under 50 words
      2. Writing in present tense, active voice
      3. Maintaining strict focus on the exact description or keywords mentioned
      4. Make sure all the information is directly related to the description or keywords provided

      The goal is to create a highly specific, searchable profile that will yield only relevant matches in the database. Write the expanded description directly, starting with the actual profile content."
    end
  end
end
