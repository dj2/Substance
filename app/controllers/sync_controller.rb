# frozen_string_literal: true

# Controller for handling syncing of feeds.
class SyncController < ApplicationController
  def feeds
    Feed.all.each { |feed| FeedCheckJob.perform_later(feed) }
    redirect_to root_url
  end
end
