class EstablishmentsController < ApplicationController
  caches_action :index, :cache_path => proc{ params.slice :q }
  caches_page :show

  respond_to :html, :json, :xml

  def index
    q = params[:search]
    s = Tire.search 'establishments' do query { string q } end
    @establishments = s.results.select { |e| e.source.downcase == request.subdomain }
    respond_with @establishments
  end

  def show
    @establishment = Establishment.find params[:id]
    respond_with @establishment
  end

end
