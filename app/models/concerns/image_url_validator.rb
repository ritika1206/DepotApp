class ImageUrlValidator < ActiveModel::EachValidator
  def validate(product)
    unless product.image_url =~ /(https?:\/\/.*\.(?:png|jpg|gif))/i
      product.errors.add :image_url, "is invalid"
    end
  end
end

