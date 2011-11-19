class PagesController < ApplicationController
  caches_page :home, :about, :api


  def home
    
  end

  def about
    render "about_#{I18n.locale}"
  end

  def api
    render "api_#{I18n.locale}"
  end

end
