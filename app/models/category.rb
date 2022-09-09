class Category < ApplicationRecord
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :products, dependent: :restrict_with_error
  has_many :sub_category_products, through: :children, dependent: :restrict_with_error, source: :products

  validates :name, presence: true
  validates :name, uniqueness: true, if: :name?
  validates :name, uniqueness: { scope: :parent_id }, if: :name?
  validate :ensure_one_level_category_nesting

  private

    def ensure_one_level_category_nesting
      parent.parent_id.nil? if parent.present?
    end
end
