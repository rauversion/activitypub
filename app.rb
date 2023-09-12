require 'sinatra'
require_relative "lib/activitypub"

# For simplicity, we'll hardcode actor_id and generate a keypair on startup
actor_id = "https://example.com/actors/1"
keypair = ActivityPub::Signature.generate_keypair
outbox = ActivityPub::Outbox.new(actor_id: actor_id, private_key: keypair[:private])

post '/actors/1/outbox' do
  target_inbox_url = params[:inbox_url] # expect the client to provide target inbox URL
  activity_data = params[:activity_data] # and the activity data

  response = outbox.send_activity(target_inbox_url, activity_data)
  [response.code.to_i, response.body]
end

post '/actors/1/inbox' do
  # This is where other actors would send activities to our actor
  incoming_activity = JSON.parse(params['incoming_activity']) # JSON.parse(request.body.read)

  # For demonstration purposes, we'll just print the activity to the console
  puts "Received activity: #{incoming_activity}"

  # Respond with a 200 OK for simplicity
  [200, "Activity received"]
end



get '/' do
  %(
    "ActivityPub Sinatra Example"
    <h2>Send an Activity to Outbox</h2>
    <form id="outboxForm" action="/actors/1/outbox" method="post">
      <label for="inbox_url">Recipient Inbox URL:</label>
      <input type="text" id="inbox_url" name="inbox_url" required value="http://recipient.com/actors/2/inbox">
      <br><br>
      <label for="activity_data">Activity Data (JSON):</label>
      <textarea id="activity_data" name="activity_data" rows="4" required>{"type":"Note","content":"Hello from Sinatra form!"}</textarea>
      <br><br>
      <input type="submit" value="Send to Outbox">
    </form>
    <br><hr><br>
    <h2>Simulate Sending an Activity to our Inbox</h2>
    <form id="inboxForm" action="/actors/1/inbox" method="post">
      <label for="incoming_activity">Incoming Activity Data (JSON):</label>
      <textarea id="incoming_activity" name="incoming_activity" rows="4" required>{"type":"Note","content":"Hello to Sinatra from form!"}</textarea>
      <br><br>
      <input type="submit" value="Send to our Inbox">
    </form>
  )
end