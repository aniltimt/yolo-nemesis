class V1::Ios::OrdersController < ApplicationController
  def create
    unless params[:platform_id].present?
      bad_request("platform_id required")
      return
    end

    params[:order] ||= {}

    if params[:order][:receipt]
      params[:order].delete(:tour_id)
    elsif params[:order][:tour_id] == nil
      bad_request("Tour id is invalid")
      return
    end

    @order = IosOrder.new(params[:order])

    # if user is preview user 
    # and 
    #   user is admin's preview_user (checked by hardcoded mail)
    #   or
    #   user is client's preview user and requested tour is client's tour
    if current_user && current_user.is_preview_user && ((current_user.email =~ /waldmanjulie@gmail.com|aminiailo@cogniance.com/) || (current_user.client && current_user.client.tours.collect{|t| t.id}.include?(params[:order][:tour_id].to_i)) )
      @order.created_from_preview_user = true
    end

    if @order.valid?
      #current_user.orders << @order
      @order.user = current_user
      @order.save

      respond_to do |format|
        format.xml {render :status => 201}
      end
    else
      bad_request("Receipt is invalid")
    end
  rescue ActiveRecord::RecordNotFound => exception
    bad_request("Tour id is invalid")
  rescue ActiveRecord::RecordNotUnique => exception
    # @TODO this exception never raises, Order model has no unique index 
    @order = Order.find_by_tour_id_and_user_id(@order.tour_id, @order.user_id)
    respond_to do |format|
      format.xml {render :status => 201}
    end
  end
end
