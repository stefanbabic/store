class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
    @count = increment_counter
    @message = "You've been here #{@count} times" if @count > 5
  end

  def increment_counter
    session[:counter] ||= 0
    session[:counter] += 1
  end
end
