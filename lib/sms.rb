class Sms
  require 'rubygems'
  require 'twilio-ruby'

  def initialize(opts, state, details = nil)
    @opts = opts
    @msg = opts[state.to_s]
    @msg << "\n" << details if details
  end

  def send
    @client = Twilio::REST::Client.new @opts['account_sid'], @opts['auth_token']
    params = Hash[:from,      @opts['from_phone'],
                  :to,        @opts['to_phone'], # we can send sms to verified numbers only, because of trial twilio account
                  :body,      @msg]

    @client.account.messages.create params
  end
end
