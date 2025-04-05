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

  ## POST /search
  def search
    input = params[:input]

    results = Sponsors::SearchService.call(input)
    recommendations = Sponsors::RecommendationService.call(input, results)

    render json: { results: results, recommendations: recommendations }, status: :ok
  end
end
