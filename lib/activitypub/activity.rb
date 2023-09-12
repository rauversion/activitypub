module ActivityPub
  class Activity
    # The type of the activity, e.g., 'Create', 'Like', 'Follow', etc.
    attr_accessor :type

    # The actor performing the activity.
    attr_accessor :actor

    # The object of the activity, e.g., a post, a comment, etc.
    attr_accessor :object

    # Any additional properties can go here.
    # ...

    def initialize(type:, actor:, object:, **other_attributes)
      @type = type
      @actor = actor
      @object = object

      # Handle other attributes as needed
      other_attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # Convert the activity into a hash representation.
    def to_h
      {
        '@context': 'https://www.w3.org/ns/activitystreams',
        type: @type,
        actor: @actor,
        object: @object
        # Add any other attributes as needed.
        # ...
      }
    end

    # Convert the activity into a JSON representation.
    def to_json(*args)
      to_h.to_json(*args)
    end

    # Load an activity from a hash.
    def self.from_h(hash)
      new(
        type: hash['type'],
        actor: hash['actor'],
        object: hash['object']
        # Handle any other attributes as needed.
        # ...
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
