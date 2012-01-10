class EstablishmentsController < ApplicationController
  caches_action :index, :cache_path => Proc.new{ |c| c.params }
  caches_page :show

  #before_filter :make_index

  respond_to :html, :json, :xml

  def index
    q = params[:q]
    s = Tire.search 'establishments' do query { string q } end
    @establishments = s.results
    respond_with @establishments
  end

  def show
    @establishment = Establishment.find(params['id'])
    respond_with @establishment, :include => :infractions
  end

  private
  
  def make_index
    Establishment.make_index
  end
end
