class Product < ApplicationRecord
  PERMALINK_REGEX = /[[:alnum:]]+/
  validates_with ImageUrlValidator, attributes: [:image_url], if: ->{ image_url.present? }

  has_many :line_items, dependent: :restrict_with_error, counter_cache: true
  has_many :orders, through: :line_items
  has_many :carts, through: :line_items
  belongs_to :category, counter_cache: true
  before_destroy :ensure_not_referenced_by_any_line_item

  after_initialize do |prod| 
    prod.title = 'abc' unless prod.title
    if prod.attributes["price"]
      prod.discount_price = prod.price unless prod.price
    end
  end

  after_create :update_total_products_count_of_category
  after_destroy :update_total_products_count_of_category

  validates :title, :description, :image_url, :price, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, if: :price_present?
  validates_comparison_of :price, greater_than: :discount_price, message: "should be greater than discount price", if: [:price_present?, :discount_price_present?]
  validates :title, uniqueness: true

  validates :permalink, uniqueness: true, format: { with: PERMALINK_REGEX, message: "no special and no space allowed in the permalink" }, if: :permalink_present?
  validates_comparison_of :words_in_permalink_separated_by_hyphen, greater_than_or_equal_to: 3, message: "permalink should contain minimun 3 words separated by hyphen", if: :permalink_present?
  validates_comparison_of :words_in_description, greater_than_or_equal_to: 5, less_than_or_equal_to: 10, if: ->{ description.present? }
  validates :category, presence: true

  scope :enabled_and_price_above, ->(price) { where("enabled = ? AND price > ?", true, price) }
  scope :products_in_cart, -> { Product.joins(:line_items) }
  scope :names_of_products_in_cart, -> { Product.joins(:line_items).pluck(:title) }

  private

    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end

    def restrict_admin_deletion
      throw :abort if email == 'admin@depot.com'
    end

    def words_in_permalink_separated_by_hyphen
      permalink.split('-').length
    end

    def words_in_description
      description.scan(/\w+/).length
    end

    def permalink_present?
      permalink.present?
    end

    def price_present?
      price.present?
    end

    def discount_price_present?
      discount_price.present?
    end

    def update_total_products_count_of_category
      category.total_products_count = category.products_count
      category.children.each { |child| category.total_products_count += child.products_count }
      category.save
    end
end
