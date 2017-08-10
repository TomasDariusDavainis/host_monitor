class Sms
  attr_reader :opts, :msg

  def initialize(opts, state, details = nil)
    @opts = opts
    @msg = opts[state.to_s]
    @msg << "\n" << details if details
  end

  def delivery
    client.account.messages.create(params)
  end

  private

  def client
    Twilio::REST::Client.new(opts['account_sid'], opts['auth_token'])
  end

  def params
    {
      from: opts['from_phone'],
      to: opts['to_phone'],
      body: msg
    }
  end
end
