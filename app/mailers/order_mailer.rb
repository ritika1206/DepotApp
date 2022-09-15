class OrderMailer < ApplicationMailer
  default from: 'admin@depot.com'
  def received
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end
  
  def shipped
    @order = order
    
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end
end
