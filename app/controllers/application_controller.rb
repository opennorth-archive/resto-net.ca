class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :subdomains

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || cookies[:locale] || :en
    cookies[:locale] = I18n.locale unless cookies[:locale] == I18n.locale
  end
      
  def requires_subdomain
    unless subdomains.include? request.subdomain
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def subdomains
    %w(montreal toronto) # edmonton gatineau ottawa vancouver
  end

  def establishments
    "#{request.subdomain.capitalize}Establishment".constantize
  end

  def inspections
    "#{request.subdomain.capitalize}Inspection".constantize
  end
end
