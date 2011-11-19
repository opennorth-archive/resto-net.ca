class PagesController < ApplicationController
  caches_page :home, :about, :api

  before_filter :load_establishments, :only => [:home,:embed]

  def home
   # load_data 10
  end

  def about
    render "about_#{I18n.locale}"
  end

  def api
    render "api_#{I18n.locale}"
  end

private

  def load_establishments
    @establishments = Establishment.geocoded
  end

  def load_data(limit)
  end

end
