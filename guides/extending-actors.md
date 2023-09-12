## Extending ActivityPub Actors in Rails

### Introduction

By default, our ActivityPub library provides a basic implementation for an actor. However, to cater to your application's specific needs, you might want to extend the default actor with custom properties and methods.

### Step 1: Define the Extended Actor Model

You can extend the actor by inheriting from the base `ActivityPub::Actor` class:

```ruby
class CustomActor < ActivityPub::Actor
  # Custom attributes
  attr_accessor :location, :birthdate

  def to_h
    super.merge({
      location: location,
      birthdate: birthdate
    })
  end
  
  def self.from_h(hash)
    actor = super(hash)
    actor.location = hash[:location]
    actor.birthdate = hash[:birthdate]
    actor
  end
end
```

Here, we've added a `location` and `birthdate` to our custom actor.

### Step 2: Modify the Rails Model

Update your Rails model (e.g., `User`) to have the custom attributes:

```ruby
class User < ApplicationRecord
  # Assuming you've added location and birthdate columns
  # to your users table
  
  def to_activitypub_actor
    CustomActor.new({
      id: activitypub_url,
      type: 'Person',
      preferredUsername: username,
      location: location,
      birthdate: birthdate.strftime('%Y-%m-%d')
    })
  end
end
```

### Step 3: Handle Incoming Activities with Extended Actor

When you receive an incoming activity, you can parse it using the custom actor:

```ruby
incoming_actor = CustomActor.from_h(received_json)
puts incoming_actor.location
puts incoming_actor.birthdate
```

### Step 4: Update the Outgoing Activities

Whenever you send out activities that include the actor, ensure that you're using the `to_activitypub_actor` method from your Rails model to get the correct representation.

### Step 5: Validation

Consider adding validations for your custom attributes to ensure the integrity of data:

```ruby
class CustomActor < ActivityPub::Actor
  # ...

  def validate
    super
    errors.add(:location, "is invalid") unless valid_location?(location)
    errors.add(:birthdate, "is invalid") unless birthdate.is_a?(Date)
  end
  
  private

  def valid_location?(loc)
    # Your logic to validate the location
  end
end
```

### Conclusion

By extending the default actor in ActivityPub, you can introduce new attributes and functionalities that cater to your application's needs. Always ensure that your custom attributes follow the ActivityPub specifications and conventions to maintain interoperability with other servers.

---

Remember, while you have the flexibility to add custom attributes, keeping the base attributes in line with the ActivityPub specification will ensure maximum compatibility with other ActivityPub servers.