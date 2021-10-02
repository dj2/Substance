# frozen_string_literal: true

# A note
class Note < ApplicationRecord
  acts_as_taggable_on :tags
  has_paper_trail

  scope :tagged, lambda { |tag|
    tagged_with(tag)
  }

  class << self
    def group_by_day(notes)
      data = []
      notes.each do |e|
        date = e.updated_at.strftime('%Y-%m-%d')
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
