# frozen_string_literal: true

# spec/activitypub/inbox_spec.rb

RSpec.describe ActivityPub::Inbox do
  let(:actor_id) { "https://example.com/actors/1" }
  let(:keypair) { ActivityPub::Signature.generate_keypair }
  let(:activity_data) { '{"type":"Note","content":"Hello, world!"}' }
  let(:headers) { { "Signature" => ActivityPub::Signature.sign(activity_data, keypair[:private]) } }
  let(:public_key_response) do
    {
      publicKey: {
        id: "#{actor_id}#main-key",
        owner: actor_id,
        publicKeyPem: keypair[:public]
      }
    }.to_json
  end

  subject { described_class.new(actor_id: actor_id) }

  # Stubbing the HTTP request to return our example public key
  before do
    allow(Net::HTTP).to receive(:get).with(URI(actor_id)).and_return(public_key_response)
  end

  describe "#accept_activity" do
    it "accepts and processes a valid activity" do
      expect { subject.accept_activity(activity_data, headers) }.not_to raise_error
    end

    it "raises an error for an activity with an invalid signature" do
      tampered_headers = headers.merge("Signature" => "INVALID_SIGNATURE")

      expect { subject.accept_activity(activity_data, tampered_headers) }.to raise_error("Invalid signature")
    end
  end
end
