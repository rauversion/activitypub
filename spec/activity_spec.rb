# frozen_string_literal: true

RSpec.describe ActivityPub::Activity do
  describe "#initialize" do
    subject { described_class.new(type: "Like", actor: "https://example.com/users/alice", object: "https://example.com/posts/1") }

    it "initializes with given attributes" do
      expect(subject.type).to eq("Like")
      expect(subject.actor).to eq("https://example.com/users/alice")
      expect(subject.object).to eq("https://example.com/posts/1")
    end
  end

  describe "#to_json" do
    subject { described_class.new(type: "Like", actor: "https://example.com/users/alice", object: "https://example.com/posts/1") }

    it "converts the activity to a JSON representation" do
      json_output = subject.to_h.to_json

      parsed_output = JSON.parse(json_output)

      expect(parsed_output["type"]).to eq("Like")
      expect(parsed_output["actor"]).to eq("https://example.com/users/alice")
      expect(parsed_output["object"]).to eq("https://example.com/posts/1")
    end
  end

  describe ".from_h" do
    let(:activity_hash) { { "type" => "Like", "actor" => "https://example.com/users/alice", "object" => "https://example.com/posts/1" } }

    it "loads an activity from a hash" do
      activity = described_class.from_h(activity_hash)

      expect(activity.type).to eq("Like")
      expect(activity.actor).to eq("https://example.com/users/alice")
      expect(activity.object).to eq("https://example.com/posts/1")
    end
  end
end
