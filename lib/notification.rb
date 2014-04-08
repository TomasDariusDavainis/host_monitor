module Notification
  def method_missing(notification_type, state, opts, details = nil)
    Kernel.const_get(notification_type.capitalize).new(opts, state, details).tap do |notification|
      notification.send
    end
  end

  def notify(state, opts, details = nil)
    opts.keys.each { |type| send(type, state, opts[type], details) if opts[type]['enabled'] == true }
  end
end
