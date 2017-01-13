require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  include ActiveJob::TestHelper

  test "buying a product" do
    start_order_count = Order.count
    sport_shoes = products(:shoes)

    get "/"
    assert_response :success
    assert_select 'h1', "Store Catalog"

    post '/line_items', params: { product_id: sport_shoes.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal sport_shoes, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_select 'legend', 'Please Enter Your Details'

    perform_enqueued_jobs do
      post "/orders", params: {
        order: {
          name:     "Stefan Babic",
          address:  "123 The Street",
          email:    "stefan@example.com",
          pay_type: "Check"
        }
      }

      follow_redirect!

      assert_response :success
      assert_select 'h1', "Store Catalog"
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size

      assert_equal start_order_count + 1, Order.count
      order = Order.last

      assert_equal "Stefan Babic",        order.name
      assert_equal "123 The Street",      order.address
      assert_equal "stefan@example.com",  order.email
      assert_equal "Check",               order.pay_type

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal sport_shoes, line_item.product

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["stefan@example.com"], mail.to
      assert_equal 'Stefan Babic <store@example.com>', mail[:from].value
      assert_equal "Sport Shoes Store Order Confirmation", mail.subject
    end
  end
end
