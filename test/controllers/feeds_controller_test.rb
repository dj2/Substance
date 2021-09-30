# frozen_string_literal: true

require 'test_helper'

class FeedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @feed = create(:feed)
  end

  test 'should get index' do
    get feeds_url
    assert_response :success
  end

  test 'should get new' do
    get new_feed_url
    assert_response :success
  end

  test 'should create feed' do
    assert_difference('Feed.count') do
      post feeds_url, params: { feed: { feed_url: 'https://example.com/url' } }
    end

    assert_redirected_to feed_url(Feed.last)
  end

  test 'should show feed' do
    get feed_url(@feed)
    assert_response :success
  end

  test 'should get edit' do
    get edit_feed_url(@feed)
    assert_response :success
  end

  test 'should update feed' do
    patch feed_url(@feed), params: { feed: { feed_url: 'https://example.com/new' } }
    assert_redirected_to feed_url(@feed)

    @feed.reload
    assert_equal 'https://example.com/new', @feed.feed_url
  end

  test 'should destroy feed' do
    assert_difference('Feed.count', -1) do
      delete feed_url(@feed)
    end

    assert_redirected_to feeds_url
  end

  test 'should assign new tags to entries' do
    e1 = create(:entry, feed: @feed)
    e1.tag_list.add('Zero')
    e1.save!

    e2 = create(:entry, feed: @feed)

    patch feed_url(@feed), params: { feed: { tag_list: 'First, Second' } }
    assert_redirected_to feed_url(@feed)

    @feed.reload
    e1.reload
    e2.reload

    assert_equal 'First, Second', @feed.tag_list.sort.join(', ')
    assert_equal 'First, Second, Zero', e1.tag_list.sort.join(', ')
    assert_equal 'First, Second', e2.tag_list.sort.join(', ')
  end
end
