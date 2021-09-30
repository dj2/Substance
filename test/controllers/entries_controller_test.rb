# frozen_string_literal: true

require 'test_helper'

class EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entry = create(:entry)
  end

  test 'show show starred' do
    @entry.starred = true
    @entry.save!

    e2 = create(:entry)
    e3 = create(:entry)
    e3.starred = true
    e3.save!

    get starred_entries_url
    assert_response :success

    assert_match @entry.title, @response.body
    assert_no_match e2.title, @response.body
    assert_match e3.title, @response.body
  end

  test 'should show entry' do
    get entry_url(@entry)
    assert_response :success

    @entry.reload
    assert @entry.read?
  end

  test 'should mark entry as unread' do
    @entry.read = true
    @entry.save!
    @entry.reload

    get unread_entry_url(@entry)
    assert_response :success

    @entry.reload
    assert_not @entry.read?
  end

  test 'should do noting if entry not read' do
    @entry.read = false
    @entry.save!
    @entry.reload

    get unread_entry_url(@entry)
    assert_response :success

    @entry.reload
    assert_not @entry.read?
  end

  test 'should set starred' do
    get star_entry_url(@entry)
    assert_redirected_to entry_url(@entry)

    @entry.reload
    assert @entry.starred?
  end

  test 'should set unstarred' do
    @entry.starred = true
    @entry.save!

    get star_entry_url(@entry)
    assert_redirected_to entry_url(@entry)

    @entry.reload
    assert_not @entry.starred?
  end
end
