class HostMonitor
  include Notification
  attr_reader :host

  def initialize(host)
    @tries = 0
    @host = host
  end

  def start
    host.ping
    if host.code.eql?("200") && host.message.eql?("Ok")
      notify(:up, $config['notification']) if @tries > 0
      exit
    else
      notify(:down, $config['notification'], host.details) if [0, 10, 20, 30].include? @tries
      @tries += 1
      sleep $config['host']['timeout'].to_i
      start
    end
  end
end
