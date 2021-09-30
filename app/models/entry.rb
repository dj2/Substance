# frozen_string_literal: true

# An individual feed entry
class Entry < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true, uniqueness: true
  validates :guid, presence: true, uniqueness: true

  belongs_to :feed

  acts_as_taggable_on :tags

  default_scope { order(published_date: :desc) }

  scope :starred, lambda {
    where(starred: true)
      .includes(:feed)
  }

  scope :unread, lambda {
    where(read: false)
      .includes(%i[feed tags])
  }

  scope :tagged, lambda { |_tag|
    tagged_with(@tag)
      .includes(%i[feed tags])
  }

  class << self
    def group_by_day(entries)
      data = []
      entries.each do |e|
        date = e.published_date.strftime('%Y-%m-%d')
        data << { date: date, entries: [] } unless date_match?(data.last, date)
        data.last[:entries] << e
      end
      data
    end

    private

    def date_match?(data, date)
      !data.nil? && data[:date] == date
    end
  end
end
