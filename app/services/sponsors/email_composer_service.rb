module Sponsors
  class EmailComposerService < ApplicationService
    def initialize(idea, sponsor_profile)
      @idea = idea
      @sponsor_profile = sponsor_profile
    end

    def call
      OpenAI::ChatService.call("Project/Campaign Idea: #{@idea}\n\nLead/Sponsor Profile: #{@sponsor_profile}", system_prompt)
    end

    private

    def system_prompt
      "You are tasked with drafting an email to reach out to a potential lead/sponsor regarding a project or campaign idea. Your objective is to effectively communicate the details of the project or campaign while demonstrating its value proposition and potential benefits to the recipient. Consider personalizing the email based on the provided lead/sponsor profile to establish a connection and increase the likelihood of engagement. The email should be professional, concise, and persuasive, aiming to capture the recipient's interest and prompt further discussion or action."
    end
  end
end
