

# ActivityPub Ruby Library

[![Maintainability](https://api.codeclimate.com/v1/badges/f1be0b7028f6e7d5b3d9/maintainability)](https://codeclimate.com/github/rauversion/activitypub/maintainability)

[![Ruby](https://github.com/rauversion/activitypub/actions/workflows/main.yml/badge.svg)](https://github.com/rauversion/activitypub/actions/workflows/main.yml)

This library provides a simple interface to work with the ActivityPub protocol in Ruby applications.

## Features
- Create and manage ActivityPub Objects.
- Send and receive Activities using Outbox and Inbox functionality.
- Signature verification for secured interactions.
- Simple Sinatra example to demonstrate usage.

For usage guides on RubyOnRails please check the[guides folder](guides/).

## Installation

```bash
gem install activitypub
```

Or add it to your Gemfile:

```ruby
gem 'activitypub'
```

Then run `bundle install`.

## Usage

### Creating an ActivityPub Object

```ruby
activity = ActivityPub::Object.new(type: "Note", content: "Hello ActivityPub!")
```

### Sending an Activity

```ruby
outbox = ActivityPub::Outbox.new("https://recipient.com/actors/2/inbox")
outbox.send(activity)
```

### Receiving an Activity

```ruby
inbox = ActivityPub::Inbox.new
received_activity = inbox.receive(request_body)
```

### Verifying Signatures

```ruby
signature = ActivityPub::Signature.new
if signature.verify(received_activity)
  puts "Signature is valid!"
else
  puts "Signature is invalid!"
end
```

## Sinatra Example

A simple Sinatra app is included to demonstrate the library's functionality. To run it:

1. Navigate to the `example` directory.
2. Run `bundle install`.
3. Run the app with `ruby app.rb`.

Visit `http://localhost:4567` to access the example interface.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss any changes or features.

## License

This library is released under the MIT License. See `LICENSE` for details.

## Sinatra app testing:

To test the Sinatra app that we just set up, you'll need to interact with its endpoints, specifically sending and receiving activities to and from the outbox and inbox respectively.

Let's first ensure that the Sinatra app is running:

1. Run the Sinatra application:
   ```bash
   bundle exec ruby app.rb
   ```

2. Visit `http://localhost:4567/` in your browser to confirm that the app is running.

**Note**: As this example is highly simplified, it doesn't handle potential errors or specific responses you'd expect from a fully-fledged ActivityPub service. Ensure that any production implementation follows the ActivityPub specification closely and manages potential risks.