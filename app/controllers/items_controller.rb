# frozen_string_literal: true

# Controller for item actions
class ItemsController < ApplicationController
  before_action :fetch_current_item, only: %i[edit update destroy]

  def index
    @pagy, @items = pagy(Item.show_completed(params[:show_completed] || 0).order_by_status_and_order,
                         items: params[:limit] || 10)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    update_order(@item, (Item.maximum(:order) || 0) + 1)

    respond_to do |format|
      if @item.save
        handle_new_turbo_success(format)
        handle_success(format)
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  def edit; end

  def update
    @item.title = item_params[:title]
    @item.description = item_params[:description]

    respond_to do |format|
      if @item.save
        handle_success(format)
      else
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @item.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@item.id) }
      handle_success(format)
    end
  end

  def toggle
    @item = Item.find(params[:id])
    updated = @item.update(status: params[:status])
    render json: { status: updated, message: "Updated: #{helpers.time_ago_in_words(@item.updated_at)} ago" }
  end

  def reorder
    new_order = params[:new_order]
    new_order.each_with_index do |element, index|
      item = Item.find(element)
      update_order(item, index)
      item.save
    end

    render json: { status: true, message: 'Successful' }
  end

  private

  def item_params
    params.require(:item).permit(:title, :description)
  end

  def fetch_current_item
    @item = Item.find(params[:id])
  end

  def handle_new_turbo_success(format)
    format.turbo_stream do
      render turbo_stream: [
        # Add the new item to the active list section
        turbo_stream.append('active_list', partial: 'items/item', locals: { item: @item }),
        # Change the new item box back to the add button
        turbo_stream.replace('new_item', partial: 'items/new_item_link')
      ]
    end
  end

  def handle_success(format)
    format.html { redirect_to items_url, notice: 'Successful' }
  end

  def update_order(item, order)
    item.order = order
  end
end
