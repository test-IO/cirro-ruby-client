# This middleware can be injected during debugging or while adding new specs
module CirroIO
  module Client
    class ResponseDebuggingMiddleware < Faraday::Response::Middleware
      def on_complete(env)
        binding.pry # rubocop:disable Lint/Debugger
      end
    end
  end
end
