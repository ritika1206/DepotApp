class Admin::ReportsController < Admin::AdminController
  def index
    if params["from"]
      @orders = Order.where(created_at: (params["from"].to_date)..(params["to"].to_date + 1))
    else
      @orders = Order.where(created_at: (Date.today - 5.day)..Date.tomorrow)
    end
  end
end
