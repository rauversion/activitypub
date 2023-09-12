# frozen_string_literal: true

RSpec.describe Activitypub do
  it "has a version number" do
    expect(Activitypub::VERSION).not_to be nil
  end
end
