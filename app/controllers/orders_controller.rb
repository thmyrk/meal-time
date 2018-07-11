class OrdersController < ApplicationController
  before_action :authenticate_with_token, except: [:index]

  def index
    render status: :ok, json: Order.all
  end

  def create
    order = Order.create!(default_order_params)
    render status: :created, json: order
  end

  def show
    order = Order.find(params[:id])
    render status: :ok, json: order
  end

  def update
    order_params = default_order_params
    order_params["payer"] = current_user if (params["order"]["status"] == "Ordered")
    order = Order.update(params[:id], order_params)
    render status: :ok, json: order
  end

  def destroy
    Order.destroy(params[:id])
    render status: :no_content, json: {}
  end

  private

  def default_order_params
    params.require(:order).permit(:name, :meals, :status)
  end
end
