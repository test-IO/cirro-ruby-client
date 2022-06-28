module CirroIOV2
  module RequestClients
    class Base
      # Interface of all request clients. It returns the response if the request was successful (HTTP::2xx) and
      # raises a CirroIOV2::HTTPError together with the response if the request was not successful

      def request(*args)
        response = make_request(*args)
        raise Errors::HTTPError, response unless response.success?

        response
      rescue Faraday::ParsingError => e
        raise Errors::ResponseNotJsonError, e
      end

      def make_request(*args)
        raise NotImplementedError
      end
    end
  end
end
