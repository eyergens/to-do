# frozen_string_literal: true

# Model for individual To-Do list items
class Item < ActiveRecord::Base
  validates :title, presence: true
  validates :status, presence: true
  validates :order, presence: true
end
