# frozen_string_literal: true

# Controller for item actions
class ItemsController < ApplicationController
  def index
    @active_items = Item.where(status: false).order(:order)
    @completed_items = Item.where(status: true).order(updated_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_url, notice: 'Successful' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.title = params[:title]
    item.description = params[:description]
    item.status = params[:status]
    item.save
  end

  def destroy
    Item.destroy(params[:id])
  end

  def toggle
    @item = Item.find(params[:id])
    updated = @item.update(status: params[:status])
    render json: { message: updated }
  end

  def item_params
    params.require(:item).permit(:title, :description)
  end
end
