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
    elsif @inspections
      # @todo
    end
    t "#{controller.controller_name}.#{controller.action_name}.title", args
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : og_description
  end

  # Open Graph tags
  def og_title
    # @todo pages#city, about, api
    if @establishments
      # @todo
    elsif @establishment
      @establishment.name
    elsif @inspections
      # @todo
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
    elsif @inspections
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

  def tweet_button(text, options = {})
    link_to t('.tweet'), 'http://twitter.com/share', {'class' => 'twitter-share-button', 'data-lang' => locale, 'data-count' => 'none', 'data-via' => 'resto_net', 'data-related' => t('.tweet_related'), 'data-text' => text}.merge(options)
  end

  def regulations
    t(:regulations).reject{|_,x| x[:exclude]}.sort_by{|_,x| x[:short]}
  end

  def regulation(regulation, options = {}, html_options = {})
    link_to regulation[:short], options, {'rel' => 'popover', 'data-title' => regulation[:article], 'data-content' => regulation[:long]}.merge(html_options)
  end

  def establishments_json(establishments)
    establishments.map do |establishment|
      inspection = establishment.inspections.first
      { url:    establishment_path(establishment),
        name:   establishment.name,
        lat:    establishment.latitude,
        lng:    establishment.longitude,
        count:  establishment.fines_count,
        total:  number_to_currency(establishment.fines_total),
        date:   l(inspection.inspection_date),
        amount: number_to_currency(inspection.amount),
        icon:   '%02d' % establishment.fines_count, # JavaScript doesn't have sprintf
      }
    end.to_json
  end

end
