class HostMonitor
  NOTIFY_FAILED_TRIES = [3, 10, 50, 100, 500].freeze
  include Notification
  attr_reader :host
  attr_accessor :failed_tries

  def initialize
    @failed_tries = 0
    @host = Host.new(config['host']['url'], config['host']['timeout'])
  end

  def start
    loop do
      if host.down?
        notify(:down, config['notification'], host.details) if NOTIFY_FAILED_TRIES.include?(failed_tries)
        self.failed_tries += 1
      elsif failed_tries.positive?
        notify(:up, config['notification'])
        self.failed_tries = 0
      end
      sleep config['host']['timeout'].to_i
    end
  end

  def config
    @config ||= File.open(config_path) { |file| YAML.load(file) }
  end

  private

  def config_path
    File.expand_path('../config/config.yml', __dir__)
  end
end
