# frozen_string_literal: true

# Controller for news pages.
class NewsController < ApplicationController
  def index
    @data = Entry.group_by_day(Entry.unread)
  end
end
