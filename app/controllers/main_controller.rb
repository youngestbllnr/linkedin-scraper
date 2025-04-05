class MainController < ApplicationController
  ## GET /
  def index; end

  ## POST /scrape
  def scrape
    username = params[:username]

    if username.present?
      ## Perform scraping in background
      ProfileScrapeWorker.perform_async(username)

      redirect_to root_path, notice: "#{username} will be added to the database in the background."
    else
      redirect_to root_path, notice: 'Invalid username, please try again.'
    end
  end

  ## POST /embed
  def embed
    input = params[:input]

    render json: {
             embedding: input.present? ? OpenAI::EmbeddingService.call(input) : nil
           }, status: :ok
  end

  ## POST /search_profiles
  def search_profiles
    input = params[:input]

    results = Profiles::SimilaritySearchService.call(input)

    render json: { results: results }, status: :ok
  end

  ## POST /search_collaborations
  def search_collaborations
    input = params[:input]

    results = Collaborations::SearchService.call(input)
    recommendations = Collaborations::RecommendationService.call(input, results)
    email = Collaborations::EmailComposerService.call(input, recommendations)

    render json: { results: results, recommendations: recommendations, email_draft: email }, status: :ok
  end
end
