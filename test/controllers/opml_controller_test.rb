# frozen_string_literal: true

require 'test_helper'

class OpmlControllerTest < ActionDispatch::IntegrationTest
  test 'should get import' do
    get opml_import_url
    assert_response :success
  end

  test 'should import feeds' do
    assert_difference('Feed.count', 3) do
      file = fixture_file_upload('opml.xml', 'application/rss+xml')
      post opml_importer_url, params: { file: file }
    end
    assert_enqueued_jobs 3
  end

  test 'should not import duplicate feeds' do
    assert_difference('Feed.count', 3) do
      file = fixture_file_upload('opml.xml', 'application/rss+xml')
      post opml_importer_url, params: { file: file }
    end
    assert_difference('Feed.count', 0) do
      file = fixture_file_upload('opml.xml', 'application/rss+xml')
      post opml_importer_url, params: { file: file }
    end
  end
end
