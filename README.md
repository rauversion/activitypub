# ActivityPub Ruby Library

This library provides a simple interface to work with the ActivityPub protocol in Ruby applications.

## Features
- Create and manage ActivityPub Objects.
- Send and receive Activities using Outbox and Inbox functionality.
- Signature verification for secured interactions.
- Simple Sinatra example to demonstrate usage.

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

Now, there are a few ways to interact with the application:

### 1. Using `curl`

**Sending an Activity to Outbox**:
Let's send a "Note" type activity to our actor's outbox which should forward it to another actor's inbox.

```bash
curl -X POST -d "inbox_url=http://recipient.com/actors/2/inbox" -d "activity_data={\"type\":\"Note\",\"content\":\"Hello from Sinatra!\"}" http://localhost:4567/actors/1/outbox
```

**Receiving an Activity in Inbox**:
You can simulate another actor sending an activity to our actor's inbox:

```bash
curl -X POST -H "Content-Type: application/json" -d "{\"type\":\"Note\",\"content\":\"Hello to Sinatra from another actor!\"}" http://localhost:4567/actors/1/inbox
```

### 2. Using a Web Browser

You can easily check the root endpoint by navigating to `http://localhost:4567/` in your browser. However, for POST requests like the outbox and inbox interactions, you'll need a tool more suited for the task.

### 3. Using Postman

[Postman](https://www.postman.com/) is a popular tool for testing API endpoints.

1. **Sending an Activity to Outbox**:
   - Set the method to `POST`.
   - URL: `http://localhost:4567/actors/1/outbox`
   - Set the headers:
     - `Content-Type: application/x-www-form-urlencoded`
   - In the body, select `x-www-form-urlencoded` and add two keys:
     - `inbox_url` with the value `http://recipient.com/actors/2/inbox`
     - `activity_data` with the value `{"type":"Note","content":"Hello from Sinatra!"}`
   - Click on "Send".

2. **Receiving an Activity in Inbox**:
   - Set the method to `POST`.
   - URL: `http://localhost:4567/actors/1/inbox`
   - Set the headers:
     - `Content-Type: application/json`
   - In the body, select `raw` and paste in `{"type":"Note","content":"Hello to Sinatra from another actor!"}`
   - Click on "Send".

**Note**: As this example is highly simplified, it doesn't handle potential errors or specific responses you'd expect from a fully-fledged ActivityPub service. Ensure that any production implementation follows the ActivityPub specification closely and manages potential risks.