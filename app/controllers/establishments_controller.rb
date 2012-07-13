class EstablishmentsController < ApplicationController
  before_filter :requires_subdomain
  caches_page :show
  caches_action :index, :cache_path => ->(c) { params.slice :q }

  respond_to :html, :json, :xml

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

    # @todo search
    #q = params[:search]
    #s = Tire.search 'establishments' do query { string q } end
    #@establishments = s.results.select { |e| e.source.downcase == request.subdomain }
  end

  def show
    @establishment = establishments.find params[:id]
    respond_with @establishment
  end

end
