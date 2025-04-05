Rails.application.routes.draw do
  # Default URL Options
  default_url_options :host => 'localhost', port: 3000 unless Rails.env.production?
  default_url_options :host => 'linkedin-scraper.up.railway.app' if Rails.env.production?

  ## Root Path
  root 'main#index'
  ## Scrape
  post 'scrape', to: 'main#scrape', as: 'scrape'

  ## Search Profiles
  post 'search_profiles', to: 'main#search_profiles', as: 'search_profiles'

  ## Search Collaborations
  post 'search_collaborations', to: 'main#search_collaborations', as: 'search_collaborations'

  ## Embed
  post 'embed', to: 'main#embed', as: 'embed'
end
