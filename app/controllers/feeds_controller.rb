# frozen_string_literal: true

# Controller for interacting with feeds.
class FeedsController < ApplicationController
  before_action :set_feed, only: %i[show edit update destroy]

  def index
    @feeds = Feed.all.order(:name)
  end

  def show; end

  def new
    @feed = Feed.new
  end

  def edit; end

  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      redirect_to @feed, notice: 'Feed was successfully created.'
    else
      render :new
    end
  end

  def update
    if @feed.update(feed_params)
      redirect_to @feed, notice: 'Feed was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @feed.destroy
    redirect_to feeds_url, notice: 'Feed was successfully destroyed.'
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:feed_url, :tag_list)
  end
end
