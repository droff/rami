require 'yaml'
require 'mongo'
require 'socket'
require_relative 'rami/daemon'
require_relative 'rami/listener'
require_relative 'rami/config'
require_relative 'rami/event'
require_relative 'rami/service'

module RAMI
  VERSION = '0.1'
end