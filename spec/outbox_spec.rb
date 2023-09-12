# spec/activitypub/outbox_spec.rb

RSpec.describe ActivityPub::Outbox do
  let(:actor_id) { "https://example.com/actors/1" }
  let(:inbox_url) { "https://recipient.com/actors/2/inbox" }
  let(:keypair) { ActivityPub::Signature.generate_keypair }
  let(:activity_data) { '{"type":"Note","content":"Hello from outbox!"}' }
  
  subject { described_class.new(actor_id: actor_id, private_key: keypair[:private]) }

  # Stubbing the HTTP request to avoid actual posts during tests
  before do
    stub_request(:post, "http://recipient.com:443/actors/2/inbox")
      .with(
        body: activity_data,
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/ld+json',
          'User-Agent'=>'Ruby',
          'Signature' => ActivityPub::Signature.sign(activity_data, keypair[:private])
        }
      )
      .to_return(status: 200, body: "", headers: {})
  end

  describe '#send_activity' do
    it 'sends the activity to the target inbox' do
      response = subject.send_activity(inbox_url, activity_data)
      expect(response.code).to eq("200")
    end
  end
end
