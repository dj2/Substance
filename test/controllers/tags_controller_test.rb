# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  test 'should get entries with tag' do
    e1 = create(:entry)
    e1.tag_list = 'Security'
    e1.save!

    e2 = create(:entry)
    e2.tag_list = 'Programming'
    e2.save!

    e3 = create(:entry)
    e3.tag_list = 'Programming'
    e3.read = true
    e3.save!

    get show_entries_tagged_url('Programming')
    assert_response :success

    assert_no_match e1.title, @response.body
    assert_match e2.title, @response.body
    assert_no_match e3.title, @response.body
  end

  test 'should get all entries with tag' do
    e1 = create(:entry)
    e1.tag_list = 'Security'
    e1.save!

    e2 = create(:entry)
    e2.tag_list = 'Programming'
    e2.save!

    e3 = create(:entry)
    e3.tag_list = 'Programming'
    e3.read = true
    e3.save!

    get all_entries_tagged_url('Programming')
    assert_response :success

    assert_no_match e1.title, @response.body
    assert_match e2.title, @response.body
    assert_match e3.title, @response.body
  end

  test 'should get notes with tag' do
    e1 = create(:note)
    e1.tag_list = 'Security'
    e1.save!

    e2 = create(:note)
    e2.tag_list = 'Programming'
    e2.save!

    e3 = create(:note)
    e3.tag_list = 'Programming'
    e3.save!

    get show_notes_tagged_url('Programming')
    assert_response :success

    assert_no_match e1.title, @response.body
    assert_match e2.title, @response.body
    assert_match e3.title, @response.body
  end
end
