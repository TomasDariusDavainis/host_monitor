class Email
  require 'net/smtp'

  attr_reader :opts, :msg

  def initialize(opts)
    @opts = opts
    @msg = %{
    From: #{opts['from_alias']} <#{opts['from']}>
    To: <#{opts['to']}>
    Subject: #{opts['subject']}

    #{opts['body']}}
  end

  def send
    Net::SMTP.new(opts['server'], opts['port']).tap do |smtp|
      smtp.enable_starttls
      smtp.start('gmail.com', opts['from'], opts['password'], :login) do |smtp_conn|
        smtp_conn.send_message msg, opts['from'], opts['to']
      end
    end
  end
end
