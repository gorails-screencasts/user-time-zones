class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_time_zone, if: :user_signed_in?

  def set_time_zone
    Time.zone = current_user.time_zone
  end

  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:timezone])
    ActiveSupport::TimeZone.all.find{ |zone| zone.tzinfo == browser_tz } || Time.zone
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    Time.zone
  end
  helper_method :browser_time_zone

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :time_zone])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :time_zone])
    end
end
