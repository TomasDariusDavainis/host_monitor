class Notification
  attr_reader :config, :details

  def initialize(config, details = nil)
    @config = config
    @details = details
  end

  def notify(state)
    sms(state).delivery if config['sms']['enabled']
    email(state).delivery if config['email']['enabled']
    true
  end

  private

  def email(state)
    Email.new(config['email'], state, details)
  end

  def sms(state)
    Sms.new(config['sms'], state, details)
  end
end
