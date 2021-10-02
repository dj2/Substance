# frozen_string_literal: true

# A note
class Note < ApplicationRecord
  acts_as_taggable_on :tags
  has_paper_trail
end
