class HostMonitor
  NOTIFY_FAILED_TRIES = [3, 10, 50, 100, 500].freeze
  attr_reader :host
  attr_accessor :failed_tries

  def initialize
    @failed_tries = 0
    @host = Host.new(config['host']['url'])
  end

  def start
    loop do
      check_availability
      sleep config['host']['rate_seconds'].to_i
    end
  end

  def config
    @config ||= File.open(config_path) { |file| YAML.load(file) }
  end

  private

  def config_path
    File.expand_path('../config/config.yml', __dir__)
  end

  def notification
    Notification.new(config['notification'], host.details)
  end

  def check_availability
    if host.down?
      notification.notify(:down) if NOTIFY_FAILED_TRIES.include?(failed_tries)
      self.failed_tries += 1
    elsif failed_tries.positive?
      notification.notify(:up)
      self.failed_tries = 0
    end
  end
end
