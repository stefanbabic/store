class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    @products = Product.order(:title)
    @count = increment_counter
    @message = "You've been here #{@count} times" if @count > 5
  end

  def increment_counter
    session[:counter] ||= 0
    session[:counter] += 1
  end
end
