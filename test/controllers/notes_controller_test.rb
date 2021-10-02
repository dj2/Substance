# frozen_string_literal: true

require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = create(:note)
  end

  test 'should get index' do
    get notes_url
    assert_response :success
  end

  test 'should get new' do
    get new_note_url
    assert_response :success
  end

  test 'should create note' do
    assert_difference('Note.count') do
      post notes_url, params: { note: { content: @note.content, title: @note.title, tag_list: 'Programming, CSS' } }
    end

    assert_redirected_to note_url(Note.last)
    assert_equal 'CSS, Programming', Note.last.tag_list.sort.join(', ')
  end

  test 'should show note' do
    get note_url(@note)
    assert_response :success
  end

  test 'should get edit' do
    get edit_note_url(@note)
    assert_response :success
  end

  test 'should update note' do
    patch note_url(@note), params: { note: { content: @note.content, title: @note.title } }
    assert_redirected_to note_url(@note)
  end
end
