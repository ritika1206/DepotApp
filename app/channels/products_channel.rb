class ProductsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_frokm 'products'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
