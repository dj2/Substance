# frozen_string_literal: true

FactoryBot.define do
  factory :feed do
    sequence(:feed_url) { |n| "https://example.com/feed/#{n}" }
  end

  factory :entry do
    sequence(:title) { |n| "Feed entry #{n}" }
    sequence(:url) { |n| "https://example.com/blog/item#{n}" }
    sequence(:guid) { |n| "https://example.com/blog/item#{n}" }
    content { 'Content' }
    published_date { DateTime.now }
    feed
  end

  factory :note do
    sequence(:title) { |n| "Note #{n}" }
    content { "Note content" }
  end
end
