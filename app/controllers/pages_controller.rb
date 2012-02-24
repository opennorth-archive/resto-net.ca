class PagesController < ApplicationController
  caches_page :home, :about, :api


  def home
    if request.subdomain
      @establishments = Establishment.where(:source => request.subdomain).geocoded
      @inspections = Inspection.type(request.subdomain).sort(:inspection_date.desc).limit(10)
      @highest_infractions = Establishment.type(request.subdomain).by_highest_inspections.limit(10)
    end
  end

  def about
    render "about_#{I18n.locale}"
  end

  def api
    render "api_#{I18n.locale}"
  end

end
