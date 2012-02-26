module ApplicationHelper
  def title
    # @todo about, api
    args = {}
    if with_subdomain?
      args[:city] = t request.subdomain, default: request.subdomain.capitalize
    end
    if @establishments
      args[:q] = params[:q]
    elsif @establishment
      args[:name] = @establishment.name
    end
    t "#{controller.controller_name}.#{controller.action_name}.title", args
  end

  # Open Graph tags
  def og_title
    # @todo pages#city, about, api
    if @establishments
      # @todo
    elsif @establishment
      @establishment.name
    elsif current_page?(controller: 'pages', action: 'index')
      'Resto-Net'
    else
      title
    end
  end

  def og_type
    # @todo pages#city, about, api
    if @establishments
      # @todo
    elsif @establishment
      # @todo
    else
      'website'
    end
  end

  def og_image
    root_url.chomp('/') + image_path('logo.gif')
  end

  # @todo more descriptive
  def og_description
    t 'layouts.application.description'
  end

  def with_subdomain?
    request.subdomain.present? && request.subdomain != 'www'
  end

  # @returns [Boolean] whether the current path is the root path
  def root?
    !with_subdomain? && request.path == root_path(locale: false)
  end

  # @returns [Boolean] whether the current path is a city root path
  def city_root?
    with_subdomain? && request.path == root_path(locale: false)
  end

  def link_to_unless_root(name, options = {}, html_options = {}, &block)
    link_to_unless root?, name, options, html_options, &block
  end

  def link_to_unless_city_root(name, options = {}, html_options = {}, &block)
    link_to_unless city_root?, name, options, html_options, &block
  end


  # @todo past this point

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : og_description
  end

  # icons from http://code.google.com/p/google-maps-icons/
  def establishments_json(establishments)
    establishments.select{|e| e.geocoded?}.map do |establishment|
      infraction = establishment.infractions.first
      {
        :id     => establishment.id,
        :lat    => establishment.latitude,
        :lng    => establishment.longitude,
        :name   => establishment.name,
        :url    => url_for(establishment),
        :count  => establishment.infractions_count,
        :amount => number_to_currency(establishment.infractions_amount),
        :latest => {
          :date   => l(infraction.judgment_date),
          :amount => number_to_currency(infraction.amount),
        },
      }
    end.to_json
  end

  def map_translations_json
    {
      :total_infractions => t(:total_infractions),
      :latest_infraction => t(:latest_infraction)
    }.to_json
  end

  def address(establishment)
    establishment.street ? establishment.street : establishment.address
  end

end
