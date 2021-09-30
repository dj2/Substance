# frozen_string_literal: true

require 'test_helper'
require_relative 'feed_parser_test_data'

class FeedParserTest < ActiveSupport::TestCase
  test 'parses feed' do
    result = FeedParser.parse(FeedParserTestData::RSS_FEED)
    assert_equal 'Feed Title', result[:name]
    assert_equal 'https://example.com/blog/', result[:site_url]
    assert_equal 'A feed description', result[:description]
    assert_equal 1, result[:entries].length

    entry = result[:entries].first
    assert_equal 'Feed Item', entry[:title]
    assert_equal 'https://example.com/guid/item1/', entry[:guid]
    assert_equal 'https://example.com/blog/item1/', entry[:url]
    assert_equal DateTime.parse('Wed, 22 Sep 2021 00:00:00 +0000'), entry[:published_date]
    assert_equal '<p>Feed item content</p>', entry[:original_content]
    assert_equal 'Feed item content', entry[:content]
  end

  test 'parses CDATA' do
    result = FeedParser.parse(FeedParserTestData::RSS_WITH_CDATA)
    assert_equal 'A Feed Title', result[:name]
    assert_equal 'https://example.com', result[:site_url]
    assert_equal 'Feed with CDATA.', result[:description]
    assert_equal 1, result[:entries].length

    entry = result[:entries].first
    assert_equal 'A CDATA Item', entry[:title]
    assert_equal 'https://example.com/guid/cdata1/', entry[:guid]
    assert_equal 'https://example.com/blog/cdata1/', entry[:url]
    assert_equal DateTime.parse('2021-09-23T14:00:00+00:00'), entry[:published_date]
    assert_equal 'A description in cdata', entry[:content]
    assert_equal '<p>A description in cdata</p>', entry[:original_content]
  end

  test 'parses dc:date' do
    result = FeedParser.parse(FeedParserTestData::RSS_WITH_DC_DATE)
    assert_equal 'A Feed', result[:name]
    assert_equal 'https://example.com', result[:site_url]
    assert_equal 'Feed description', result[:description]
    assert_equal 1, result[:entries].length

    entry = result[:entries].first
    assert_equal 'A feed item', entry[:title]
    assert_equal 'https://example.com/guid/date1', entry[:guid]
    assert_equal 'https://example.com/blog/date1', entry[:url]
    assert_equal DateTime.new(2021, 9, 23, 14, 0, 0), entry[:published_date]
    assert_equal '...', entry[:content]
  end

  test 'parses no date' do
    result = FeedParser.parse(FeedParserTestData::RSS_NO_DATE)
    assert_equal 1, result[:entries].length

    entry = result[:entries].first
    assert_not entry[:published_date].nil?
  end

  test 'content:encoded takes precedence over description' do
    result = FeedParser.parse(FeedParserTestData::RSS_CONTENT_ENCODED)
    assert_equal 1, result[:entries].length, 1
    assert_equal 'content', result[:entries].first[:content]
  end

  test 'atom feed' do
    result = FeedParser.parse(FeedParserTestData::ATOM_FEED)
    assert_equal 'Feed Title', result[:name]
    assert_equal 'https://example.com', result[:site_url]
    assert_equal 'Feed description', result[:description]
    assert_equal 2, result[:entries].length

    entry = result[:entries].first
    assert_equal 'Entry Title 1', entry[:title]
    assert_equal 'https://example.com/guid/entry1', entry[:guid]
    assert_equal 'https://example.com/blog/entry1', entry[:url]
    assert_equal DateTime.new(2021, 5, 26, 18, 6), entry[:published_date]
    assert_equal '<p>Content text 1</p>', entry[:original_content]
    assert_equal 'Content text 1', entry[:content]

    entry = result[:entries].last
    assert_equal 'Entry Title 2', entry[:title]
    assert_equal 'https://example.com/guid/entry2', entry[:guid]
    assert_equal 'https://example.com/blog/entry2', entry[:url]
    assert_equal DateTime.new(2021, 5, 24, 18, 6), entry[:published_date]
    assert_equal 'Summary Text 2', entry[:original_content]
    assert_equal 'Summary Text 2', entry[:content]
  end

  test 'atom feed invalid html' do
    result = FeedParser.parse(FeedParserTestData::ATOM_BAD_HTML)
    assert_equal 'Feed Title', result[:name]
    assert_equal 'https://example.com', result[:site_url]
    assert_equal 'Feed description', result[:description]
    assert_equal 1, result[:entries].length

    entry = result[:entries].first
    assert_equal 'Entry Title 1', entry[:title]
    assert_equal 'https://example.com/guid/entry1', entry[:guid]
    assert_equal 'https://example.com/blog/entry1', entry[:url]
    assert_equal DateTime.new(2021, 5, 26, 18, 6), entry[:published_date]
    assert_equal "<p>Content text 1<p></p>\n </p>", entry[:original_content]
    assert_equal 'Content text 1', entry[:content]
  end
end
