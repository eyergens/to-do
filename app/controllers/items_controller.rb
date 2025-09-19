# frozen_string_literal: true

# Controller for item actions
class ItemsController < ApplicationController
  before_action :fetch_current_item, only: %i[edit update destroy]

  def index
    @active_items = Item.where(status: false).order(:order)
    @completed_items = Item.where(status: true).order(updated_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.order = Item.maximum(:order) + 1

    respond_to do |format|
      if @item.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.append('active-list', partial: 'items/item', locals: { item: @item }),
            turbo_stream.replace('new_item', partial: 'items/new_item_link')
          ]
        }
        format.html { redirect_to items_url, notice: 'Successful' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    @item.title = item_params[:title]
    @item.description = item_params[:description]

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_url, notice: 'Successful' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@item.id) }
      format.html { redirect_to items_url, notice: 'Task was successfully deleted.' }
    end
  end

  def toggle
    @item = Item.find(params[:id])
    updated = @item.update(status: params[:status])
    render json: { status: updated, message: @item.updated_at.strftime('%b %d, %Y %I:%M%p') }
  end

  def item_params
    params.require(:item).permit(:title, :description)
  end

  def fetch_current_item
    @item = Item.find(params[:id])
  end
end
