class PagesController < ApplicationController
  caches_page :index, :about, :api

  def index
  end

  def city
    @latest_inspections = []
    @latest_fines = []
    @most_fines = []
    @highest_fines = []
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

end
