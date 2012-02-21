class EstablishmentsController < ApplicationController
  caches_action :index, :cache_path => Proc.new{ |c| c.params }
  caches_page :show

  respond_to :html, :json, :xml

  def index
    if params[:search]
      q = params[:search]
      s = Tire.search 'establishments' do query { string q } end
      @establishments = s.results
      respond_with @establishments
    else
      @establishments = Establishment.where(:source => params[:source])
      respond_with @establishments
    end
  end

  def show
    @establishment = Establishment.find(params['id'])
    respond_with @establishment
  end

end
