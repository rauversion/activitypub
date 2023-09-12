# frozen_string_literal: true

# spec/activitypub/object_spec.rb

RSpec.describe ActivityPub::Object do
  let(:current_time) { Time.now.utc.iso8601 }

  describe "#initialize" do
    subject { described_class.new(id: "https://example.com/objects/1", content: "Hello world!") }

    it "initializes with given attributes" do
      expect(subject.id).to eq("https://example.com/objects/1")
      expect(subject.type).to eq("Object")
      expect(subject.content).to eq("Hello world!")
      expect(subject.published).to be_a(String) # Checking if it's a formatted string for simplicity. In a real-world scenario, you might want to parse and validate.
      expect(subject.updated).to be_a(String)
    end
  end

  describe "#to_json" do
    subject { described_class.new(id: "https://example.com/objects/1", content: "Hello world!", published: current_time, updated: current_time) }

    it "converts the object to a JSON representation" do
      json_output = subject.to_json
      parsed_output = JSON.parse(json_output)

      expect(parsed_output["id"]).to eq("https://example.com/objects/1")
      expect(parsed_output["type"]).to eq("Object")
      expect(parsed_output["content"]).to eq("Hello world!")
      expect(parsed_output["published"]).to eq(current_time)
      expect(parsed_output["updated"]).to eq(current_time)
    end
  end

  describe ".from_h" do
    let(:object_hash) { { "id" => "https://example.com/objects/1", "type" => "Object", "content" => "Hello world!", "published" => current_time, "updated" => current_time } }

    it "loads an object from a hash" do
      obj = described_class.from_h(object_hash)

      expect(obj.id).to eq("https://example.com/objects/1")
      expect(obj.type).to eq("Object")
      expect(obj.content).to eq("Hello world!")
      expect(obj.published).to eq(current_time)
      expect(obj.updated).to eq(current_time)
    end
  end
end
