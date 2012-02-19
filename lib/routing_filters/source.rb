require 'routing_filter'
module RoutingFilter
  class Source < Filter
    # remove the locale from the beginning of the path, pass the path
    # to the given block and set it to the resulting params hash

    def around_recognize(path, env, &block)
      source = nil
      path.sub! %r(^/(montreal|toronto)(?=/|$)) do source = $1; '' end
      $source = source
      yield.tap do |params|
        params[:source] = source
      end
    end

    def around_generate(*args, &block)
      params = args.extract_options!
      source = params.delete(:source) || $source
      yield.tap do |result|
        result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{source}#{$2}" }
      end
    end

  end
                                                                                                      end
