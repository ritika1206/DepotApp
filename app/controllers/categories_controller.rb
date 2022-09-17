class CategoriesController < ApplicationController
  def books
    if category = Category.find_by(id: params[:id])
      @books = category.products
      @sub_category_books = category.sub_category_products
    end
  end

  def index
    @categories = Category.all
  end
end
