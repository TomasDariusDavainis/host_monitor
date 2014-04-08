class Host
  require 'net/https'
  attr_reader :host, :timeout
  attr_accessor :message, :code

  def initialize(host, timeout)
    @host = host
    @timeout = timeout
  end

  def ping
    url = URI.parse(host)
    response = Net::HTTP.get_response(url)
    self.code, self.message = response.code, response.message
  rescue SocketError, Timeout::Error
    self.code, self.message = '404', 'can\'t resolve hostname'
  end

  def details
<<DET
Host: #{host}
Status code: #{code}
Message: #{message}
DET
  end
end