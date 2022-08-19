class Product < ApplicationRecord
  include ActiveModel::Validations
  validates_with ImageUrlValidator

  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, comparision: { greater_than: :discount_price }
  validates :title, uniqueness: true

  validates :permalink, uniqueness: true, format: { with: /[[:alnum:]]+/, message: "no special and no space allowed in the permalink" }
  validates_comparision_of :words_in_permalink_separated_by_hyphen, greater_than_or_equal_to: 3, message: "permalink should contain minimun 3 words separated by hyphen"
  validates_comparision_of :words_in_description, greater_than_or_equal_to: 5, less_than_equal_to: 10

  private

    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end

    def words_in_permalink_separated_by_hyphen
      self.permalink.split('-').length
    end

    def words_in_description
      self.desciption.scan('\w+').length
    end
end
