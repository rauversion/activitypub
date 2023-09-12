Registering with another ActivityPub server, often called "following" in the context of social interactions, typically involves a few steps:

1. **Discovering the Actor on the remote server**: Before you can follow someone (or some entity), you need to discover their unique ActivityPub ID (usually a URL).

2. **Sending a `Follow` activity**: To start the following process, your server sends a `Follow` activity to the remote server.

3. **Remote server responds**: The remote server then acknowledges this with an `Accept` or `Reject` activity.

To implement this in a Rails context, you'd likely want some combination of models, controllers, and views (forms). Here's a basic guide:

### 1. Discovering the Actor:

#### a. Form to input Actor ID:

You can create a simple form where a user can paste or type in the ActivityPub ID of the actor they want to follow.

```erb
<%= form_with(url: discover_actor_path, method: :post) do |f| %>
  <%= f.label :actor_id, "Enter Actor's ActivityPub ID" %>
  <%= f.text_field :actor_id %>
  <%= f.submit "Discover" %>
<% end %>
```

### 2. Sending a `Follow` activity:

#### a. Displaying the discovered Actor:

Once you've fetched the Actor's data (like their name, avatar, summary, etc.), present it to the user and offer an option to follow.

```erb
<% if @actor %>
  <h2><%= @actor.name %></h2>
  <%= image_tag @actor.avatar_url %>
  <p><%= @actor.summary %></p>
  <%= button_to "Follow", follow_actor_path(actor_id: @actor.id), method: :post %>
<% end %>
```

#### b. Sending the `Follow` Activity:

When the "Follow" button is pressed, construct and send a `Follow` activity to the remote server.

```ruby
def follow
  actor_id = params[:actor_id]
  # Construct your `Follow` activity
  activity = {
    '@context': 'https://www.w3.org/ns/activitystreams',
    'type': 'Follow',
    'actor': current_user.activitypub_id,
    'object': actor_id
  }
  # Send this to the remote server
  # ...
end
```

### 3. Handling the remote server's response:

You'll want to handle incoming activities (like `Accept` or `Reject` in response to your `Follow`). If the remote actor accepts, store this relationship in your database, perhaps with a `Following` model.

### Tips:

1. **Webfinger**: Some platforms use Webfinger to make discovering users easier. Instead of needing the full ActivityPub ID, you can type in a username like `@user@domain.com`, and the server translates that into an ActivityPub ID.

2. **Security**: Always validate incoming and outgoing data. ActivityPub deals with external servers, so there's an inherent risk.

3. **Feedback for Users**: Give feedback to your users. Let them know when the follow request has been sent, and again when it's been accepted or rejected.

4. **Idempotency**: If a user tries to follow an actor they're already following, handle this gracefully. Maybe send an `Undo` `Follow` activity or simply notify the user they're already following the actor.

5. **Error Handling**: The remote server might not be available, or there might be other issues with the `Follow` request. Handle these gracefully with appropriate error messages.

Following this guide, you can create a simple yet functional interface for your Rails app's users to follow actors on remote ActivityPub servers.