class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  ## Sessions
  # Clear Session Data
  def clear_session
    session.clear
  end

  # Create Do-Not-Track Session
  def do_not_track
    session[:do_not_track] = true unless session[:do_not_track]
  end
end
