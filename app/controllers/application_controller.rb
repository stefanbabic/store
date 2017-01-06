class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :time_loaded

  private
  def time_loaded
    @time = Time.now.strftime("%H:%M - %d.%m.%Y")
  end
end
