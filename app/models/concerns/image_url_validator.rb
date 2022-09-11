class ImageUrlValidator < ActiveModel::EachValidator
  IMAGE_REGEX = /(https?:\/\/.*\.(?:png|jpg|gif))/i
  def validate_each(product, attribute_image_url, image_url)
    unless image_url =~ IMAGE_REGEX
      product.errors.add attribute_image_url, "is invalid"
    end
  end
end

