module CirroIOV2
	module Resources
		class NotificationLayout < Base
			ALLOWED_PARAMS = [:name, :templates]

			def create(params)
				params_allowed?(params, ALLOWED_PARAMS)
				response_object(client.request_client.request(:post, resource_root, params))
			end
		end
	end
end
