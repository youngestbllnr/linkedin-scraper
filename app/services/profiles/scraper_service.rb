module Profiles
  class ScraperService < ApplicationService
    VERSIONS = {
      document: 'v1',
      biography: 'v2',
      html: 'v3'
    }

    def initialize(username, version = VERSIONS[:document], data = nil)
      @username = username
      @version = version
      @data ||= data
    end

    def call
      @data ||= LinkedInService.call(@username)

      OpenAI::ChatService.call(@data.to_json, system_prompt)
    end

    private

    def system_prompt
      case @version
      when VERSIONS[:document]
        # Document Format
        "You are tasked with generating a comprehensive profile for a specific individual using provided data in JSON format, extracted from their LinkedIn profile. Your objective is to parse the JSON data and compile ALL information and data points into a coherent PLAIN-TEXT document without any additional formatting. The document should offer a detailed overview of the person's professional background, skills, experiences, and accomplishments. Your profile should be thorough and well-organized, providing a comprehensive snapshot of the individual's professional identity based on the JSON data provided."
      when VERSIONS[:biography]
        # Biography Format
        "You are tasked with creating a detailed biography for a specific individual using provided data in JSON format, extracted from their LinkedIn profile. Your objective is to parse the JSON data and craft a comprehensive and engaging narrative that encapsulates the person's professional journey, achievements, skills, and experiences. Your biography should be well-structured and captivating, offering readers a vivid portrayal of the individual's professional identity based on the JSON data provided. It should include all information and data points from the JSON data provided."
      when VERSIONS[:html]
        # HTML Format
        "You are tasked with generating a comprehensive profile for a specific individual using provided data in JSON format, extracted from their LinkedIn profile. Your objective is to parse the JSON data and compile ALL information and data points into a coherent document written in HTML. The document should offer a detailed overview of the person's professional background, skills, experiences, and accomplishments. Your profile should be thorough and well-organized, providing a comprehensive snapshot of the individual's professional identity based on the JSON data provided."
      else
        # Generic Format
        "You are tasked with generating a comprehensive profile for a specific individual using provided data from their LinkedIn profile. Your objective is to compile all relevant information and data points into a coherent document that offers a detailed overview of the person's professional background, skills, experiences, and accomplishments. Your profile should be thorough and well-organized, providing a comprehensive snapshot of the individual's professional identity based on the data provided."
      end
    end
  end
end
