class EstablishmentsController < ApplicationController
  before_filter :requires_subdomain
  caches_page :show
  caches_action :index, cache_path: ->(c) do
    params.slice :q # @todo http://broadcastingadam.com/2012/07/advanced_caching_part_1-caching_strategies/
 end

  respond_to :html, :json, :xml

  # @todo implement geospatial and fulltext search
  def index
    case params[:order]
    when 'fines_count', 'fines_total'
      @attribute = params[:order].to_sym
      @direction = :desc
    else
      @attribute = :name
      @direction = :asc
    end
    @establishments = establishments.sort(@attribute.send(@direction)).limit(50)
    @maximum = @establishments.first[@attribute].to_i
    respond_with @establishments
  end

  def show
    @establishment = establishments.find params[:id]
    respond_with @establishment
  end

end
