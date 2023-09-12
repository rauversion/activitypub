# frozen_string_literal: true

module ActivityPub
  # The Activity class represents a specific action or event in the ActivityPub protocol.
  # It encapsulates details of the action being taken and any associated metadata.
  # This class provides methods for creating, validating, and processing activities
  # in accordance with the ActivityPub standard.
  class Activity
    attr_accessor :id, :type, :actor, :object, :target, :published, :to, :cc, :bcc, :context

    # Initializes a new Activity instance.
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
    end

    # Validate the activity attributes.
    def valid?
      validate_type && validate_actor && validate_object
    end

    # Convert the Activity object into a hash representation.
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

    # Generate an Activity object from a given hash.
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

    private

    # Validate the type attribute. ActivityStreams specifies a set of core activity types.
    # For simplicity, let's validate against a subset of them.
    def validate_type
      valid_types = %w[Create Update Delete Follow Like Add Remove Block Undo]
      valid_types.include?(@type)
    end

    # Validate the actor attribute. For this example, we'll just ensure it's present.
    def validate_actor
      !@actor.nil? && !@actor.empty?
    end

    # Validate the object attribute. For this example, we'll ensure it's present.
    def validate_object
      !@object.nil? && !@object.empty?
    end

    # Additional validations and methods based on scenarios can be added here.
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
