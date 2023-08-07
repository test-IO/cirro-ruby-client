module CirroIOV2
  module RequestClients
    class Base
      # Interface of all request clients. It returns the response if the request was successful (HTTP::2xx) and
      # raises a CirroIOV2::HTTPError together with the response if the request was not successful

      def request(*args, **named_args)
        response = make_request(*args, **named_args)
        raise Errors::HTTPError, response unless response.success?

        response
      rescue Faraday::ParsingError => e
        # Temporarily handle "You are being redirected step and make request to target location" 
        # Strictly unrecommended to show this hack to children and to people with heart disease
        raise Errors::ResponseNotJsonError, e unless e.response.status >= 300

        # args [method, path]
        args[1] = e.response.headers['location']
        request(*args, **named_args)
      end

      def make_request(*args)
        raise NotImplementedError
      end
    end
  end
end
