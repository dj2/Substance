# frozen_string_literal: true

# Controller for tags pages.
class TagsController < ApplicationController
  before_action :set_tag, only: [:show_entries, :all_entries, :show_notes]

  def index
    @tags = ActsAsTaggableOn::Tag.all.order(:name)
  end

  def show_entries
    @data = Entry.group_by_day(
                Entry.tagged(@tag).where(read: false))
    render :show_entries
  end

  def all_entries
    @data = Entry.group_by_day(Entry.tagged(@tag))
    render :show_entries
  end

  def show_notes
    @data = Note.group_by_day(Note.tagged(@tag))
    render :show_notes
  end

  private

  def set_tag
    @tag = ActsAsTaggableOn::Tag.where(name: params[:id]).first
  end
end
