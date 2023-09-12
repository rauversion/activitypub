# frozen_string_literal: true

module ActivityPub
  # The Activity class represents a specific action or event in the ActivityPub protocol.
  # It encapsulates details of the action being taken and any associated metadata.
  # This class provides methods for creating, validating, and processing activities
  # in accordance with the ActivityPub standard.
  class Activity
    attr_accessor :id, :type, :actor, :object, :target, :published, :to, :cc, :bcc, :context

    KNOWN_TYPES = %w[Create Update Delete Follow Accept Reject Add Remove Block Like].freeze

    def initialize(attributes = {})
      @id = attributes[:id]
      @type = attributes[:type]
      @actor = attributes[:actor]
      @object = attributes[:object]
      @target = attributes[:target]
      @published = attributes[:published] || Time.now.utc.iso8601
      @to = attributes[:to]
      @cc = attributes[:cc]
      @bcc = attributes[:bcc]
      @context = attributes[:context]

      validate!
    end

    def validate!
      validate_required_fields!
      validate_known_types!
      validate_url_format!(@id)
      validate_url_format!(@actor)
      validate_url_format!(@object)
      validate_url_format!(@target)
      validate_timestamp_format!(@published)
    end

    def validate_required_fields!
      raise "Required field 'type' is missing" unless @type
      raise "Required field 'actor' is missing" unless @actor
      raise "Required field 'object' is missing" unless @object
    end

    def validate_known_types!
      raise "'#{@type}' is not a recognized activity type" unless KNOWN_TYPES.include?(@type)
    end

    def validate_url_format!(url)
      raise "Invalid URL format: '#{url}'" unless url.nil? || url.match?(URI::DEFAULT_PARSER.make_regexp)
    end

    def validate_timestamp_format!(timestamp)
      Time.iso8601(timestamp)
    rescue ArgumentError
      raise "Invalid timestamp format: '#{timestamp}'"
    end

    def to_h
      {
        id: @id,
        type: @type,
        actor: @actor,
        object: @object,
        target: @target,
        published: @published,
        to: @to,
        cc: @cc,
        bcc: @bcc,
        context: @context
      }
    end

    def self.from_h(hash)
      Activity.new(
        id: hash["id"],
        type: hash["type"],
        actor: hash["actor"],
        object: hash["object"],
        target: hash["target"],
        published: hash["published"],
        to: hash["to"],
        cc: hash["cc"],
        bcc: hash["bcc"],
        context: hash["context"]
      )
    end
  end
end

# Usage example:

# ruby
# Copy code
# activity = ActivityPub::Activity.new(type: 'Like', actor: 'https://example.com/users/alice', object: 'https://example.com/posts/1')
# puts activity.to_json

# loaded_activity = ActivityPub::Activity.from_h(JSON.parse(activity.to_json))
# puts loaded_activity.type # => "Like"
# Note that this is a basic and illustrative implementation.
# In a real-world scenario, you would need to handle more attributes, validations,
# and scenarios specified by the ActivityStreams and ActivityPub specifications.
