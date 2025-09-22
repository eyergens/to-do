# frozen_string_literal: true

require 'test_helper'

# Test for the methods of the Items Controller
class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = Item.create!(title: 'Sample Item', description: 'Initial description', status: false, order: 1)
  end

  test 'should get index' do
    Item.create!(title: 'Active Item', description: 'Active description', status: false, order: 2)
    Item.create!(title: 'Completed Item', description: 'Completed description', status: true, order: 3)
    get items_url
    assert_response :success
  end

  test 'should get new' do
    get new_item_url
    assert_response :success
  end

  test 'should create item and redirect for valid creation' do
    assert_difference('Item.count', 1) do
      post items_url, params: { item: { title: 'New Item', description: 'New description' } }
    end

    assert_redirected_to items_url
    assert_equal 'Successful', flash[:notice]
  end

  test 'should render new for invalid item creation' do
    post items_url, params: { item: { title: '', description: 'No title' } }
    assert_response :unprocessable_entity
  end

  test 'should get edit' do
    get edit_item_url(@item)
    assert_response :success
  end

  test 'should update item and redirect for valid update' do
    patch item_url(@item), params: { item: { title: 'Updated Title', description: 'Updated Description' } }
    assert_redirected_to items_url
    assert_equal 'Successful', flash[:notice]

    @item.reload
    assert_equal 'Updated Title', @item.title
    assert_equal 'Updated Description', @item.description
  end

  test 'should render edit form for invalid update' do
    patch item_url(@item), params: { item: { title: '', description: 'Updated Description' } }
    assert_response :unprocessable_entity
  end

  test 'should destroy item and redirect to index' do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
    assert_equal 'Successful', flash[:notice]
  end

  test 'should toggle item status and return valid JSON' do
    patch toggle_item_url(@item), params: { status: true }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert(json_response['status'], 'Response status should be true')
    assert_match(/Updated: .* ago/, json_response['message'], 'Response message should include a time phrase')
  end

  test 'should reorder items and return valid JSON' do
    second_item = Item.create!(title: 'Second Item', description: 'Desc', status: false, order: 2)
    new_order = [second_item.id, @item.id]

    post reorder_items_url, params: { new_order: new_order }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert(json_response['status'], 'Reorder should return a successful status')
    assert_equal 'Successful', json_response['message']

    second_item.reload
    @item.reload
    assert_equal 0, second_item.order
    assert_equal 1, @item.order
  end
end
