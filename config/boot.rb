lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'net/https'
require 'yaml'
require 'notification'
require 'email'
require 'sms'
require 'host'
require 'host_monitor'
