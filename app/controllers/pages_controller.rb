class PagesController < ApplicationController
  caches_page :home, :about, :api


  def home
    if request.subdomain
      @establishments = Establishment.where(:source => request.subdomain)
    end
  end

  def about
    render "about_#{I18n.locale}"
  end

  def api
    render "api_#{I18n.locale}"
  end

end
