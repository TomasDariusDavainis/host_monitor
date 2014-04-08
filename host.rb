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
    return response.code, response.message
  end
end
