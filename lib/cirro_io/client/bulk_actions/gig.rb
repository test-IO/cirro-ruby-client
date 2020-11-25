module CirroIO
  module Client
    module BulkActions
      class Gig < Base
        def self.bulk_create(payload)
          response = post('gigs', payload)

          if response.status == 201
            JSON.parse(response.body)['data']
          else
            nil
          end
        end

        def self.bulk_archive(gig_id, payload)
          response = post("gigs/#{gig_id}/archive", payload)

          if response.status == 201
            JSON.parse(response.body)['data']
          else
            nil
          end
        end
      end
    end
  end
end
