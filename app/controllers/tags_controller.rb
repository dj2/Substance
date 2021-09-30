# frozen_string_literal: true

# Controller for tags pages.
class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all.order(:name)
  end

  def show
    @tag = params[:id]
    @data = Entry.group_by_day(
                Entry.tagged(@tag).where(read: false))
  end

  def all
    @tag = params[:id]
    @data = Entry.group_by_day(Entry.tagged(@tag))
    render :show
  end
end
