require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title:       "New shoes",
                          description: "Fresh shoes directly from factory!",
                          image_url:   "shoes.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title:       "Name of the shoes",
                description: "Some new description",
                image_url:   image_url,
                price:       15)
  end

  test "image url" do
    ok = %w{ adidas.gif adidas.jpg adidas.png ADIDAS.JPG Adidas.Gif
             http://a.b.c/x/y/z/adidas.gif }
    bad = %w{ adidas.doc adidas.gif/more adidas.jpg.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valit without a unique title" do
    product = Product.new(title:       products(:shoes).title,
                          description: "123",
                          image_url:   "adidas.jpg",
                          price:       45)

    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
end
