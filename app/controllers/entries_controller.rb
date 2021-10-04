# frozen_string_literal: true

# Controller for interacting with feed entries
class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show star read unread]

  def starred
    @entries = Entry.starred
  end

  def show
    return if @entry.read

    @entry.read = true
    @entry.save
  end

  def read
    @entry.read = true
    @entry.save
    render json: 'ok'
  end

  def unread
    if @entry.read?
      @entry.read = false
      @entry.save
    end
    render :show
  end

  def star
    @entry.starred = !@entry.starred
    @entry.save
    redirect_to entry_url(@entry)
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end
end
