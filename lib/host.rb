class Host
  attr_reader :url, :response
  attr_writer :message, :code

  def initialize(host)
    @url = URI.parse(host)
  end

  def details
    <<~DET
      Host: #{ url }
      Status code: #{ code }
      Message: #{ message }
    DET
  end

  def down?
    ping!
    (400..599).include?(code)
  end

  private

  def code
    return @code if @code
    ping!
    self.code = response.code.to_i
  end

  def message
    return @message if @message
    ping!
    self.message = response.message
  end

  def ping!
    @response = perform_request
  end

  def perform_request
    Net::HTTP.get_response(url)
  rescue SocketError, Timeout::Error
    MockResponse.new(404, 'Network error')
  end
end
