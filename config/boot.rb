lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'net/https'
require 'net/smtp'
require 'yaml'
require 'mock_response'
require 'notification'
require 'email'
require 'sms'
require 'host'
require 'host_monitor'
require 'rubygems'
require 'twilio-ruby'
