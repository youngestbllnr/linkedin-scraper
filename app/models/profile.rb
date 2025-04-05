class Profile < ApplicationRecord
  has_neighbors :embedding

  validates :username, uniqueness: true
  before_save :classify

  def refresh
    updated_data = LinkedInService.call(username)

    version = Profiles::ScraperService::VERSIONS[:document]
    updated_document = Profiles::ScraperService.call(username, version, updated_data).strip.gsub("\n", ' ')

    updated_embedding = OpenAI::EmbeddingService.call(updated_document)

    update!(metadata: updated_data, document: updated_document, embedding: updated_embedding)
  end

  def classify(overwrite = false)
    if overwrite || classification.blank?
      self.classification = Profiles::ClassifierService.call(document)
    end
  end
end
