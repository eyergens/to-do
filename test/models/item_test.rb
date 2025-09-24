# frozen_string_literal: true

require 'test_helper'

# Test for the methods of the Items Model
class ItemTest < ActiveSupport::TestCase
  def setup
    @valid_attributes = {
      title: 'Sample To-Do',
      status: true,
      order: 1
    }
  end

  test 'should be valid with valid attributes' do
    item = Item.new(@valid_attributes)
    assert item.valid?
  end

  test 'should be invalid without a title' do
    attributes = @valid_attributes.merge(title: nil)
    item = Item.new(attributes)
    refute item.valid?
    assert_includes item.errors[:title], "can't be blank"
  end

  test 'should be invalid without an order' do
    attributes = @valid_attributes.merge(order: nil)
    item = Item.new(attributes)
    refute item.valid?
    assert_includes item.errors[:order], "can't be blank"
  end

  test 'should be invalid without a status' do
    attributes = @valid_attributes.merge(status: nil)
    item = Item.new(attributes)
    refute item.valid?
    assert_includes item.errors[:status], 'is not included in the list'
  end

  test 'should be valid with status as false' do
    attributes = @valid_attributes.merge(status: false)
    item = Item.new(attributes)
    assert item.valid?
  end
end
