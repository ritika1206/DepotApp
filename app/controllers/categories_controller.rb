class CategoriesController < ApplicationController
  def books
    category = Category.find_by(id: params[:id])
    @books = category.products
    @sub_category_books = category.sub_category_products
  end
end
