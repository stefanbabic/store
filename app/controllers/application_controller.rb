class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :time_loaded
  before_action :authorize
  before_action :set_i18n_locale_from_params

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

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] =
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

end
