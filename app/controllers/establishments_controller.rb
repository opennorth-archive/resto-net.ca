class EstablishmentsController < ApplicationController
  caches_action :index, :cache_path => Proc.new{ |c| c.params }
  caches_page :show

  respond_to :html, :json, :xml

  before_filter :load_establishments, :only => [:index]

  def index
    respond_with @establishments
  end

  def show
    @establishment = Establishment.find(params['id'])
    respond_with @establishment, :include => :infractions
  end
end
