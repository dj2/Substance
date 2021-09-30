# frozen_string_literal: true

# Controller for handling OPML interactions.
class OpmlController < ApplicationController
  def import; end

  def importer
    OpmlParser.parse(params[:file].read).each do |f|
      next if Feed.where(feed_url: f[:feed_url]).present?

      FeedCheckJob.perform_later(Feed.create(f))
    end

    redirect_to root_url
  end
end
