# frozen_string_literal: true

# Model for individual To-Do list items
class Item < ActiveRecord::Base
  validates :title, presence: true
  validates :status, inclusion: { in: [true, false] }
  validates :order, presence: true
end
