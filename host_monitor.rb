class HostMonitor

  require_relative 'notification'
  include Notification
  attr_reader :host

  def initialize(host)
    @tries = 0
    @host = host
  end

  def start
    host.ping
    if host.code.eql?("200") && host.message.eql?("Ok")
      if @tries > 0
        email(:up, $config['notification']['email'])
      end
      exit
    else
      if [0, 10, 100].include? @tries
        sms(:down, $config['notification']['sms'], host.details)
        email(:down, $config['notification']['email'], host.details)
      end
      @tries += 1
      sleep 10
      start
    end
  end

end
