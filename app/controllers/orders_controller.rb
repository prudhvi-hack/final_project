class OrdersController < ApplicationController
  def index
    if current_user.role == "customer"
      render :index, locals: { all_orders: current_user.orders.all.confirmed_orders,
                               hidden_status: true,
                               second_title: "Previous orders" }
    else
      render :index, locals: { all_orders: Order.all.confirmed_orders,
                               hidden_status: false,
                               second_title: "Previous Orders" }
    end
  end

  def pay
    order = Order.find(params[:id])
    if order.orderitems.notexist.count != 0
      not_existed_entries = order.orderitems.notexist
      not_existed_entries.each do |entry_name|
        flash[:error] = "The Item #{entry_name} is not available,remove to continue"
      end
      redirect_to cart_path
    else
      order.ordered = true
      order.status = "ordered"
      order.date = DateTime.now
      order.save
      flash[:success] = "Order placed succesfully with id #{order.id}"
      redirect_to orders_path
    end
  end

  def cart
    render :cart
  end

  def update
    ensure_ownerorclerk_logged_in
    order = Order.find(params[:id])
    order.delivered_at = (order.delivered_at == nil) ? DateTime.now : nil
    order.save
    redirect_to orders_path
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy
    params.delete(:id)
    redirect_to action: "index"
  end

  def show
    order = Order.find(params[:id])
    user = order.user
    unless current_user.role == "owner" || current_user.role == "billclerk" || current_user == user
      flash[:error] = "Order not found"
      redirect_to "/" and return
    end
    render :show
  end

  def reorder
    old_order = Order.find(params[:id])
    new_order = current_user.orders.cart_order
    old_order.orderitems.available.each do |orderitem|
      new_order_item = orderitem.dup
      new_order_item.order_id = new_order.id
      new_order_item.save!
    end
    not_existed_entries = old_order.orderitems.notexist
    not_existed_entries.each do |entry_name|
      flash[:error] = "The Item #{entry_name} is not available,so not added"
    end
    redirect_to cart_path
  end
end
