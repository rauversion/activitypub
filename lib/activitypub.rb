# frozen_string_literal: true

require "json"
require 'time'
require 'base64'
require_relative "activitypub/version"
require_relative "activitypub/activity"
require_relative "activitypub/object"
require_relative "activitypub/actor"
require_relative "activitypub/signature"
require_relative "activitypub/inbox"
require_relative "activitypub/outbox"

module Activitypub
  class Error < StandardError; end
  # Your code goes here...
end
