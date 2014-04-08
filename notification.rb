module Notification
  require_relative 'email'
  require_relative 'sms'

  def method_missing(notification_type, state, opts, details = nil)
    Kernel.const_get(notification_type.capitalize).new(opts, state, details).tap do |notification|
      notification.send
    end
  end
end
