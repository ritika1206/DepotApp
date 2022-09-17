class Admin::AdminController < ApplicationController
  before_action :restrict_non_admin_access
  def index
    @total_orders = Order.count
  end

  def categories
    @categories = Category.all
  end

  private
    def restrict_non_admin_access
      unless @logged_in_user.admin?
        redirect_to store_index_url, notice: "You don't have privilege to access this section"
      end
    end
end
