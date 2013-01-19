class InspectionsController < ApplicationController
  before_filter :requires_subdomain
  caches_page :index

  respond_to :html, :json, :xml

  # @todo get facet counts
  def index
    @inspections = inspections
    # @todo make less montreal-specific
    if params[:q]
      regulation = t(:regulations).find{|_,v| v[:citation].slug == params[:q]}
      if regulation
        @inspections = @inspections.where(description: regulation.first)
      else
        raise ActionController::RoutingError.new('Not Found') # @todo handle more gracefully
      end
    end
    @inspections = @inspections.sort(:inspection_date.desc).limit(25) # @todo paginate
    respond_with @inspections
  end
end
