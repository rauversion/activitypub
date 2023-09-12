# The ActivityPub::Actor represents individual and 
# collective entities which perform activities.
# Commonly used actor types include Person, Organization, 
# Service, etc. For simplicity, we will focus on the Person 
# actor type.

# Here's a basic representation for the ActivityPub::Actor:

module ActivityPub
  class Actor
    attr_accessor :id, :type, :name, :preferred_username, :inbox, :outbox, :followers, :following

    def initialize(id:, type: 'Person', name:, preferred_username:, inbox:, outbox:, followers: nil, following: nil)
      @id                = id
      @type              = type
      @name              = name
      @preferred_username = preferred_username
      @inbox             = inbox
      @outbox            = outbox
      @followers         = followers
      @following         = following
    end

    def to_h
      {
        '@context': 'https://www.w3.org/ns/activitystreams',
        id: @id,
        type: @type,
        name: @name,
        preferredUsername: @preferred_username,
        inbox: @inbox,
        outbox: @outbox,
        followers: @followers,
        following: @following
      }.reject { |_, v| v.nil? }
    end

    def to_json(*args)
      to_h.to_json(*args)
    end

    def self.from_h(hash)
      new(
        id: hash['id'],
        type: hash['type'] || 'Person',
        name: hash['name'],
        preferred_username: hash['preferredUsername'],
        inbox: hash['inbox'],
        outbox: hash['outbox'],
        followers: hash['followers'],
        following: hash['following']
      )
    end
  end
end
