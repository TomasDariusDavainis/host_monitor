class Email
  attr_reader :opts, :msg

  def initialize(opts, state, details = nil)
    @opts = opts
    @msg = <<~EOF
      From: #{ opts['from_alias'] } <#{ opts['from'] }>
      To: <#{ opts['to'] }>
      Subject: #{ opts[state.to_s]['subject'] }
      #{ opts[state.to_s]['body'] }
    EOF
    @msg << details if details
  end


  def delivery
    Net::SMTP.new(opts['server'], opts['port']).tap do |smtp|
      smtp.enable_starttls
      smtp.start('gmail.com', opts['from'], opts['password'], :login) do |smtp_conn|
        smtp_conn.send_message msg, opts['from'], opts['to']
      end
    end
  end
end
