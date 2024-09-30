# app/channels/post_channel.rb

class PostChannel < ApplicationCable::Channel
  def subscribed
    # Any setup needed when the channel is subscribed
  end

  def unsubscribed
    # Any cleanup needed when the channel is unsubscribed
  end

  # Additional methods as needed
end