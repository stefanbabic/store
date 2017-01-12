require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    assert_equal "Sport Shoes Store Order Confirmation", mail.subject
    assert_equal ["stefan@example.org"], mail.to
    assert_equal ["store@example.com"], mail.from
    assert_match /1 x Adidas Zero/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Sport Shoes Store Order Shipped", mail.subject
    assert_equal ["stefan@example.org"], mail.to
    assert_equal ["store@example.com"], mail.from
    assert_match /<td>1&times;<\/td>\s*<td>Adidas Zero<\/td>/, mail.body.encoded
  end

end
