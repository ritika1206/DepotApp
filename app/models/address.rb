class Address < ApplicationRecord
  belongs_to :user

  validate :num_digits_in_pincode

  private
    def num_digits_in_pincode
      pincode.Math.log10(self).to_i + 1 == 6
    end
end
