class PagesController < ApplicationController
  caches_page :index, :about, :api

  def index
  end

  def city
    if subdomains.include? request.subdomain
      @boxes = {}
      unless establishments.only_fines?
        @boxes[:latest_inspections] = inspections.where(source: request.subdomain).sort(:updated_at.desc).limit(10)
      end
      if establishments.has_fines?
        @boxes[:latest_fines]  = inspections.where(source: request.subdomain).sort(:updated_at.desc).limit(10)
        @boxes[:most_fines]    = establishments.where(source: request.subdomain).sort(:fines_count.desc).limit(10)
        @boxes[:highest_fines] = establishments.where(source: request.subdomain).sort(:fines_total.desc).limit(10)
      end
      @spaces = 4 - @boxes.size
    else
      raise ActionController::RoutingError.new('Not Found') # @todo
    end
  end

  def about
    render "about_#{I18n.locale}"
  end

  def api
    render "api_#{I18n.locale}"
  end

  def channel
    render layout: false
  end

private

  def subdomains
    %w(montreal) # @todo
  end

  def establishments
    "#{request.subdomain.capitalize}Establishment".constantize
  end

  def inspections
    "#{request.subdomain.capitalize}Inspection".constantize
  end
end
