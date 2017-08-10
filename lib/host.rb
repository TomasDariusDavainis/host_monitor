class Host
  attr_reader :host, :timeout, :url
  attr_accessor :message, :code

  def initialize(host, timeout)
    @host = host
    @timeout = timeout
    @url = URI.parse(host)
  end

  def details
    <<~DET
      Host: #{ host }
      Status code: #{ code }
      Message: #{ message }
    DET
  end

  def down?
    ping
    (400..599).include?(code)
  end

  private

  def ping
    response = Net::HTTP.get_response(url)
    self.code = response.code.to_i
    self.message = response.message
  rescue SocketError, Timeout::Error
    self.code = 404
    self.message = 'Network error'
  end
end
