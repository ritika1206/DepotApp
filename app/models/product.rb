class Product < ApplicationRecord
  PERMALINK_REGEX = /[[:alnum:]]+/

  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :price, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, if: :price?
  validates_comparison_of :price, greater_than: :discount_price, message: "should be greater than discount price", if: [:price?, :discount_price?]
  validates :price, price_greater_than_discount_price: true, if: [:price?, :discount_price?]
  validates :title, uniqueness: true
  validates :image_url, image_url: true, if: :image_url?

  validates :permalink, uniqueness: true, format: { with: PERMALINK_REGEX, message: "no special and space allowed in the permalink" }, if: :permalink?
  validates_comparison_of :words_in_permalink_separated_by_hyphen, greater_than_or_equal_to: 3, message: "permalink should contain minimun 3 words separated by hyphen", if: :permalink?
  validates_comparison_of :words_in_description, greater_than_or_equal_to: 5, less_than_or_equal_to: 10, if: ->{ description.present? }

  private

    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end

    def words_in_permalink_separated_by_hyphen
      permalink.split('-').length
    end

    def words_in_description
      description.scan(/\w+/).length
    end
end
