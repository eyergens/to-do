# frozen_string_literal: true

# Model for individual To-Do list items
class Item < ActiveRecord::Base
  validates :title, presence: true
  validates :status, inclusion: { in: [true, false] }
  validates :order, presence: true

  scope :order_by_status_and_order, -> { order(:status, :order) }
  scope :show_completed, ->(completed) { where(status: false) if completed.to_i.zero? }
end
