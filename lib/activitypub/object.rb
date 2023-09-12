# frozen_string_literal: true

module ActivityPub
  # The Object class represents the primary data structure of the ActivityPub protocol.
  # It provides a foundational element from which specific ActivityPub types (like "Note" or "Event") derive.
  # This class facilitates the creation, validation, and manipulation of ActivityPub objects.
  class Object
    attr_accessor :id, :type, :published, :updated, :content, :attributed_to

    def initialize(id:, type: "Object", published: nil, updated: nil, content: nil, attributed_to: nil)
      @id            = id
      @type          = type
      @published     = published || Time.now.utc.iso8601
      @updated       = updated || Time.now.utc.iso8601
      @content       = content
      @attributed_to = attributed_to
    end

    def to_h
      {
        '@context': "https://www.w3.org/ns/activitystreams",
        id: @id,
        type: @type,
        published: @published,
        updated: @updated,
        content: @content,
        attributedTo: @attributed_to
      }.reject { |_, v| v.nil? }
    end

    def to_json(*args)
      to_h.to_json(*args)
    end

    def self.from_h(hash)
      new(
        id: hash["id"],
        type: hash["type"] || "Object",
        published: hash["published"],
        updated: hash["updated"],
        content: hash["content"],
        attributed_to: hash["attributedTo"]
      )
    end
  end
end

#   obj = ActivityPub::Object.new(id: 'https://example.com/objects/1', content: 'Hello world!')
# puts obj.to_json
#
# loaded_obj = ActivityPub::Object.from_h(JSON.parse(obj.to_json))
# puts loaded_obj.content # => "Hello world!"
#
