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
      "You are an expert at identifying and describing ideal collaborators for business projects and campaigns. Your task is to analyze the provided project/campaign idea and generate a comprehensive collaborator profile.

      Generate a detailed description that includes:
      1. Industry expertise and background
      2. Company size and type
      3. Key capabilities and resources
      4. Strategic alignment with the project
      5. Potential value-add to the collaboration

      Guidelines:
      - Write in present tense, using active voice
      - Be specific and detailed in descriptions
      - Focus on concrete capabilities and qualifications
      - Avoid hypothetical language (no \"would\" or \"should\")
      - Write directly without meta-text or framing
      - Keep the tone professional and business-focused
      - Ensure the description aligns with the project's specific needs

      Format the response as a clear, concise paragraph that flows naturally while covering all key aspects of the ideal collaborator."
    end
  end
end
