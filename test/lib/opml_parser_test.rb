# frozen_string_literal: true

require 'test_helper'
require_relative 'opml_parser_test_data'

class OpmlParserTest < ActiveSupport::TestCase
  test 'parses' do
    result = OpmlParser.parse(OpmlParserTestData::OPML_FILE)
    assert_equal 3, result.length

    feed = result[0]
    assert_equal 'A List Apart: The Full Feed', feed[:name]
    assert_equal 'https://alistapart.com/', feed[:site_url]
    assert_equal 'https://alistapart.com/main/feed/', feed[:feed_url]
    assert feed[:tag_list].empty?

    feed = result[1]
    assert_equal 'Accidentally in Code', feed[:name]
    assert_equal 'https://cate.blog/', feed[:site_url]
    assert_equal 'https://cate.blog/feed/', feed[:feed_url]
    assert_equal 'Code, Programming', feed[:tag_list]

    feed = result[2]
    assert_equal 'Schneier on Security', feed[:name]
    assert_equal 'https://www.schneier.com/', feed[:site_url]
    assert_equal 'https://www.schneier.com/feed/', feed[:feed_url]
    assert_equal 'Security', feed[:tag_list]
  end
end
