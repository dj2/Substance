# frozen_string_literal: true

require 'test_helper'

class NewsControllerTest < ActionDispatch::IntegrationTest
  test 'should get unread entries' do
    e1 = create(:entry)
    e1.tag_list = 'Programming'
    e1.save!

    e2 = create(:entry)
    e2.read = true
    e2.save!

    e3 = create(:entry)

    get root_url
    assert_response :success

    assert_match e1.title, @response.body
    assert_no_match e2.title, @response.body
    assert_match e3.title, @response.body
  end
end
