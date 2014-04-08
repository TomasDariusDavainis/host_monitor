class HostMonitor
  include Notification
  attr_reader :host

  def initialize(host)
    @tries = 0
    @host = host
  end

  def start
    host.ping
    if host.match(/5\d\d|404/)
      notify(:down, $config['notification'], host.details) if [3, 10, 50, 100, 500].include? @tries
      @tries += 1
      sleep $config['host']['timeout'].to_i
      start
    else
      notify(:up, $config['notification']) if @tries > 0
      exit
    end
  end
end
