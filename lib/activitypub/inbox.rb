require 'net/http'
require 'json'

module ActivityPub
  class Inbox
    attr_reader :actor_id

    def initialize(actor_id:)
      @actor_id = actor_id
    end

    def accept_activity(activity_data, headers)
      # Fetch the actor's public key
      public_key = fetch_actor_public_key(actor_id)

      # Extract the signature from headers
      signature = headers["Signature"]

      # Verify the activity's signature
      unless ActivityPub::Signature.verify?(activity_data, signature, public_key)
        raise "Invalid signature"
      end

      # Process activity
      process_activity(activity_data)
    end

    private

    def fetch_actor_public_key(actor_id)
      # Fetch the actor's profile
      uri = URI(actor_id)
      response = Net::HTTP.get(uri)
      profile = JSON.parse(response)

      # This assumes the public key is stored under a 'publicKey' key in the actor's profile.
      # This structure may vary based on the implementation details of the server hosting the actor's profile.
      profile['publicKey']['publicKeyPem']
    end

    def process_activity(activity_data)
      puts "Received activity: #{activity_data}"
    end
  end
end
