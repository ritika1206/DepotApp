class ImageUrlValidator < ActiveModel::EachValidator
  def validate(product)
    unless product.image_url =~ /(https?:\/\/.*\.(?:png|jpg|gif))/i
      product.error.add :image_url, "invalid image url"
    end
  end

