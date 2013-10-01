#!/usr/bin/env ruby
require './irc_name_resolver'
require './mysql_client'
require 'yaml'


config = YAML.load_file('config.yaml')
p config
mysql_client = MySQLClient.new(config[:mysql])
inr = IRCNameResolver.new(config[:irc], mysql_client)
inr.run
