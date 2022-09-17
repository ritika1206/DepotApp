class Address < ApplicationRecord
  belongs_to :user

  validates :pincode, length: { is: 6 }
end
