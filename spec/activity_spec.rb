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

  describe "#initialize" do
    context "when required fields are missing" do
      it "raises an error if type is missing" do
        expect do
          ActivityPub::Activity.new(actor: "http://actor.example.com", object: "http://object.example.com")
        end.to raise_error("Required field 'type' is missing")
      end

      it "raises an error if actor is missing" do
        expect do
          ActivityPub::Activity.new(type: "Create", object: "http://object.example.com")
        end.to raise_error("Required field 'actor' is missing")
      end

      it "raises an error if object is missing" do
        expect do
          ActivityPub::Activity.new(type: "Create", actor: "http://actor.example.com")
        end.to raise_error("Required field 'object' is missing")
      end
    end

    context "when an unknown type is provided" do
      it "raises an error" do
        expect do
          ActivityPub::Activity.new(type: "UnknownType", actor: "http://actor.example.com", object: "http://object.example.com")
        end.to raise_error("'UnknownType' is not a recognized activity type")
      end
    end

    context "when an invalid URL format is provided" do
      it "raises an error for invalid actor URL" do
        expect do
          ActivityPub::Activity.new(type: "Create", actor: "invalid_actor", object: "http://object.example.com")
        end.to raise_error("Invalid URL format: 'invalid_actor'")
      end

      it "raises an error for invalid object URL" do
        expect do
          ActivityPub::Activity.new(type: "Create", actor: "http://actor.example.com", object: "invalid_object")
        end.to raise_error("Invalid URL format: 'invalid_object'")
      end
    end

    context "when an invalid timestamp is provided" do
      it "raises an error" do
        expect do
          ActivityPub::Activity.new(type: "Create", actor: "http://actor.example.com", object: "http://object.example.com", published: "invalid_timestamp")
        end.to raise_error("Invalid timestamp format: 'invalid_timestamp'")
      end
    end
  end

  describe "#to_h" do
    let(:activity) do
      ActivityPub::Activity.new(
        type: "Create",
        actor: "http://actor.example.com",
        object: "http://object.example.com",
        target: "http://target.example.com",
        to: ["http://recipient1.example.com", "http://recipient2.example.com"],
        cc: ["http://cc1.example.com"]
      )
    end

    it "returns a hash representation of the activity" do
      expect(activity.to_h).to include({
                                         id: nil,
                                         type: "Create",
                                         actor: "http://actor.example.com",
                                         object: "http://object.example.com",
                                         target: "http://target.example.com",
                                         # published: a_kind_of(String), # As this is generated, we just check the type
                                         to: ["http://recipient1.example.com", "http://recipient2.example.com"],
                                         cc: ["http://cc1.example.com"],
                                         bcc: nil,
                                         context: nil
                                       })

      expect(activity.to_h[:published]).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/)
    end
  end

  describe ".from_h" do
    let(:hash_representation) do
      {
        "type" => "Create",
        "actor" => "http://actor.example.com",
        "object" => "http://object.example.com",
        "target" => "http://target.example.com",
        "to" => ["http://recipient1.example.com", "http://recipient2.example.com"],
        "cc" => ["http://cc1.example.com"]
      }
    end

    it "returns an activity instance from a hash representation" do
      activity = ActivityPub::Activity.from_h(hash_representation)
      expect(activity.type).to eq("Create")
      expect(activity.actor).to eq("http://actor.example.com")
      expect(activity.object).to eq("http://object.example.com")
      expect(activity.target).to eq("http://target.example.com")
      expect(activity.to).to eq(["http://recipient1.example.com", "http://recipient2.example.com"])
      expect(activity.cc).to eq(["http://cc1.example.com"])
    end
  end
end
