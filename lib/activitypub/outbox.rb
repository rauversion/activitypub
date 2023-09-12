# frozen_string_literal: true

require "net/http"

module ActivityPub
  # The Outbox class is responsible for sending activities to other actors.
  # It wraps the process of preparing an activity, signing it, and then delivering it to
  # the recipient's inbox. This ensures that messages sent via ActivityPub are
  # authenticated and securely delivered.
  class Outbox
    attr_reader :actor_id, :private_key

    def initialize(actor_id:, private_key:)
      @actor_id = actor_id
      @private_key = private_key
    end

    # Simulate sending a new activity to a target actor's inbox
    def send_activity(target_inbox_url, activity_data)
      # Sign the activity data
      signature = ActivityPub::Signature.sign(activity_data, private_key)

      # Send the signed activity to the target actor's inbox
      post_activity(target_inbox_url, activity_data, signature)

      # Save the activity in the outbox (not implemented here for simplicity, but would be in a real-world scenario)
      # save_activity(activity_data)
    end

    private

    def post_activity(inbox_url, activity_data, signature)
      uri = URI(inbox_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/ld+json", "Signature" => signature })
      request.body = activity_data
      http.request(request)
    end
  end
end
