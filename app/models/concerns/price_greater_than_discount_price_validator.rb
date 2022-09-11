class PriceGreaterThanDiscountPriceValidator < ActiveModel::EachValidator
  def validate_each(product, attribute_price, price)
    if price < product.discount_price
      product.errors.add attribute_price, "should be greater than discount price"
    end
  end
end
