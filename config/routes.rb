Rails.application.routes.draw do
  # Default URL Options
  default_url_options :host => 'localhost', port: 3000 unless Rails.env.production?
  default_url_options :host => 'linkedin-scraper.up.railway.app' if Rails.env.production?

  ## Root Path
  root 'main#index'
  ## Scrape
  post 'scrape', to: 'main#scrape', as: 'scrape'

  ## Search
  post 'search', to: 'main#search', as: 'search'

  ## Embed
  post 'embed', to: 'main#embed', as: 'embed'
end
