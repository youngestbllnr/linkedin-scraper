module Profiles
  class ClassifierService < ApplicationService
    def initialize(profile_document)
      ## Document generated on Profiles::ScraperService
      @profile_document = profile_document
    end

    def call
      OpenAI::ChatService.call(@profile_document, system_prompt)
    end

    private

    def system_prompt
      "Given a profile document in text format, you are tasked with classifying the individual into one of the following categories: Talent, Investor, or Founder. The profile document contains information about the person's professional background, skills, experiences, and accomplishments. Your objective is to analyze the document and determine which category best describes the individual based on the provided information. ONLY provide the classification label."
    end
  end
end
