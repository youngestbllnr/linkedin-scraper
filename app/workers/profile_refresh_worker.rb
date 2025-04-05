class ProfileRefreshWorker
  include Sidekiq::Worker

  def perform(username)
    Profile.find_by(username: username)&.refresh
  end
end
