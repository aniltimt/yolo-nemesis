class V1::OrdersController < ApplicationController
  def index
    unless params[:platform_id].present?
      bad_request("platform_id required")
      return
    end

    @orders = current_user.orders
  end
end