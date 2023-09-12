RSpec.describe ActivityPub::Actor do
  describe '#initialize' do
    subject do
      described_class.new(
        id: 'https://example.com/users/alice',
        name: 'Alice',
        preferred_username: 'alice',
        inbox: 'https://example.com/users/alice/inbox',
        outbox: 'https://example.com/users/alice/outbox'
      )
    end

    it 'initializes with given attributes' do
      expect(subject.id).to eq('https://example.com/users/alice')
      expect(subject.type).to eq('Person')
      expect(subject.name).to eq('Alice')
      expect(subject.preferred_username).to eq('alice')
      expect(subject.inbox).to eq('https://example.com/users/alice/inbox')
      expect(subject.outbox).to eq('https://example.com/users/alice/outbox')
    end
  end

  describe '#to_json' do
    subject do
      described_class.new(
        id: 'https://example.com/users/alice',
        name: 'Alice',
        preferred_username: 'alice',
        inbox: 'https://example.com/users/alice/inbox',
        outbox: 'https://example.com/users/alice/outbox'
      )
    end

    it 'converts the actor to a JSON representation' do
      json_output = subject.to_json
      parsed_output = JSON.parse(json_output)

      expect(parsed_output['id']).to eq('https://example.com/users/alice')
      expect(parsed_output['type']).to eq('Person')
      expect(parsed_output['name']).to eq('Alice')
      expect(parsed_output['preferredUsername']).to eq('alice')
      expect(parsed_output['inbox']).to eq('https://example.com/users/alice/inbox')
      expect(parsed_output['outbox']).to eq('https://example.com/users/alice/outbox')
    end
  end

  describe '.from_h' do
    let(:actor_hash) do
      {
        'id' => 'https://example.com/users/alice',
        'type' => 'Person',
        'name' => 'Alice',
        'preferredUsername' => 'alice',
        'inbox' => 'https://example.com/users/alice/inbox',
        'outbox' => 'https://example.com/users/alice/outbox'
      }
    end

    it 'loads an actor from a hash' do
      actor = described_class.from_h(actor_hash)

      expect(actor.id).to eq('https://example.com/users/alice')
      expect(actor.type).to eq('Person')
      expect(actor.name).to eq('Alice')
      expect(actor.preferred_username).to eq('alice')
      expect(actor.inbox).to eq('https://example.com/users/alice/inbox')
      expect(actor.outbox).to eq('https://example.com/users/alice/outbox')
    end
  end
end