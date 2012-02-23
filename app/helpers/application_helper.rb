module ApplicationHelper
  def javascript(*args)
    content_for :head, javascript_include_tag(*args)
  end

  def title
    content_for?(:title) ? content_for(:title) : t(:app_title)
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : t(:meta_description)
  end

  def render_establishment_partial(establishment)
    case establishment.source
      when 'toronto'
        render :partial => 'toronto'
      when 'montreal'
        render :partial => 'montreal'
      when 'vancouver'
        render :partial => 'vancouver'
    end
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

  def remove_subdomain(domain)
    domain.sub(/(montreal|toronto)\.(.*)$/, '\\2')
  end

  # http://railscasts.com/episodes/221-subdomains-in-rails-3
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, remove_subdomain(request.domain), request.port_string].join
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end

end
