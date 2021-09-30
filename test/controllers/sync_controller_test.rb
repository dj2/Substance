# frozen_string_literal: true

require 'test_helper'

class SyncControllerTest < ActionDispatch::IntegrationTest
  test 'should sync feeds' do
    create(:feed)
    create(:feed)

    get sync_feeds_url
    assert_response :redirect
    assert_enqueued_jobs 2
  end
end
