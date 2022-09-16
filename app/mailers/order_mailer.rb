class OrderMailer < ApplicationMailer
  default from: 'admin@depot.com'
  def received(order)
    @order = order
    I18n.with_locale(User.language_preferences[order.user.language_preference]) do
      mail to: order.email, subject: 'Pragmatic Store Order Confirmation' 
    end
  end
  
  def shipped(order)
    @order = order
    I18n.with_locale User.language_preferences[order.user.language_preference] { mail to: order.email, subject: 'Pragmatic Store Order Shipped' }
  end

  def all_orders_confirmation(user)
    @orders = user.orders

    I18n.with_locale(User.language_preferences[user.language_preference]) do
      mail to: user.email, subject: 'Pragmatic Store Order Confirmation'
    end
  end
end
