# frozen_string_literal: true

# Job to sync feeds in the background.
class FeedCheckJob < ApplicationJob
  queue_as :default

  def perform(feed)
    feed.sync
    feed.save!
  end
end
