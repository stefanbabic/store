class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :time_loaded
  before_action :authorize

  private

    def time_loaded
      @time = Time.now.strftime("%H:%M - %d.%m.%Y")
    end

  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end

end
