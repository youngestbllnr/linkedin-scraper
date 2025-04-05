class ProfileScrapeWorker
  include Sidekiq::Worker

  def perform(username)
    if Profile.exists?(username: username)
      Profile.find_by(username: username).refresh
    else
      data = LinkedInService.call(username)

      version = Profiles::ScraperService::VERSIONS[:document]
      document = Profiles::ScraperService.call(username, version, data).strip.gsub("\n", ' ')

      embedding = OpenAI::EmbeddingService.call(document)

      Profile.create!(username: username, document: document, embedding: embedding, metadata: data)
    end
  end
end
