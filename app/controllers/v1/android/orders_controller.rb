class V1::Android::OrdersController < ApplicationController
  def create
    unless params[:platform_id].present?
      bad_request("platform_id required")
      return
    end

    params[:order] ||= {}

    if params[:order][:receipt] && params[:order][:signature]
      params[:order].delete(:tour_id)
      @receipt = AndroidReceipt.new(params[:order][:receipt], params[:order][:signature])
      if !@receipt.valid?
        bad_request("Receipt is invalid")
        return
      end
      tour_ids = @receipt.product_ids
    elsif params[:order][:tour_id] == nil
      bad_request "Bad request - no tour id given"
      return
    else
      tour_ids = [params[:order][:tour_id]]
    end

    @orders = []
    tour_ids.each do |tour|
      begin
        @order = AndroidOrder.new
        @order.tour = Tour.find(tour)

        # if user is preview user 
        # and 
        #   user is admin's preview_user (checked by hardcoded mail)
        #   or
        #   user is client's preview user and requested tour is client's tour
        if current_user && current_user.is_preview_user && ((current_user.email =~ /waldmanjulie@gmail.com|aminiailo@cogniance.com/) || (current_user.client && current_user.client.tours.collect{|t| t.id}.include?(params[:order][:tour_id].to_i)) )
          @order.created_from_preview_user = true
        end

        @order.user = current_user
        @order.save
      rescue ActiveRecord::RecordNotFound => exception
        bad_request("Tour id is invalid")
        return
      rescue ActiveRecord::RecordNotUnique => exception
        @order = Order.find_by_tour_id_and_user_id(@order.tour_id, @order.user_id)
      end
      @orders << @order
    end
    respond_to do |format|
      format.xml {render :status => 201}
    end
  end
end
