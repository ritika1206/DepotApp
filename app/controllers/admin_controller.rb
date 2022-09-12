class AdminController < ApplicationController
  before_action :restrict_non_admin_access
  def index
    @total_orders = Order.count
  end

  def reports
    if params["from"]
      @orders = Order.where(created_at: (params["from"].to_date)..(params["to"].to_date + 1))
    else
      @orders = Order.where(created_at: (Date.today - 5.day)..Date.tomorrow)
    end
  end

  private
    def restrict_non_admin_access
      unless @logged_in_user.role == 'admin'
        redirect_to store_index_url, notice: "You don't have privilege to access this section"
      end
    end
end
