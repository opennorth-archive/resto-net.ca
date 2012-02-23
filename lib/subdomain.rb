# http://railscasts.com/episodes/221-subdomains-in-rails-3
class Subdomain
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www'
  end
end
