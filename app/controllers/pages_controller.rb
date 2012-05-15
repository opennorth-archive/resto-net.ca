class PagesController < ApplicationController
  before_filter :requires_subdomain, only: :city
  caches_page :index, :about, :api

  def index
  end

  # @note don't need to filter by source, as class filters by city already
  def city
    @establishments = establishments.geocoded
    unless establishments.only_fines?
      @inspections = inspections.sort(:inspection_date.desc).limit(10)
    end
    if establishments.has_fines?
      @fines          = inspections.fined.sort(:inspection_date.desc).limit(10)
      @fines_count    = establishments.sort(:fines_count.desc).limit(10)
      @fines_total    = establishments.sort(:fines_total.desc).limit(10)
      # To scale the small bar graphs.
      @max_fine_count = @fines_count.first.fines_count
      @max_fine_total = @fines_total.first.fines_total.to_i
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

  def mapaq_request
    @establishment = MontrealEstablishment.find(params[:establishment_id]) if params[:establishment_id]
    if params[:email]
      MapaqMailer.mail(params[:email][:cc], params[:email][:message], params[:email][:subject], params[:email][:name])
      @message = params[:email][:message]
    end
    render 'mapaq_request'
  end

private

  def establishments
    "#{request.subdomain.capitalize}Establishment".constantize
  end

  def inspections
    "#{request.subdomain.capitalize}Inspection".constantize
  end
end
