#!/usr/bin/env ruby

require 'cinch'
require 'mysql2-cs-bind'

conf = {
  :server => "irc.freenode.net",
  :channels => ["#hogemoge"],
  :nick => 'msoabot',
  :realname => 'mosabot',
  :user => 'mosabot',
}

class NameResolver

  def initialize(conf)
    @client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "", :database => "irc_resolver")
    _self = self

    @bot = Cinch::Bot.new do

      configure do |c|
        c.server    = conf[:server]
        c.channels  = conf[:channels]
        c.nick      = conf[:nick]
        c.realname  = conf[:realname]
        c.user      = conf[:user]
      end

      on :message, /^register/ do |m|
        (command, nickname, realname) = m.message.split("\s")
        _self.insert(nickname, realname)
        m.reply("registerd: nick:#{nickname} to real:#{realname}")
      end

      on :message, /^unregister/ do |m|
        (command, nickname, realname) = m.message.split("\s")
        _self.delete(nickname, realname)
        m.reply("unregistered: nick:#{nickname} to real:#{realname}")
      end

      on :message, /^nick\?/ do |m|
        (command, realname) = m.message.split("\s")
        if nickname =  _self.select_by_real(realname)
          m.reply("#{realname}'s nickname: #{nickname}")
        else
          m.reply("#{realname} is not registerd.")
        end
      end

      on :message, /^real\?/ do |m| (command, nickname) = m.message.split("\s")
        if realname = _self.select_by_nick(nickname)
          m.reply("#{nickname}'s realname: #{realname}")
        else
          m.reply("#{nickname} is not registerd.")
        end
      end

      on :message, /^ping$/ do |m|
        m.reply("pong")
      end
    end

    def insert (nickname, realname)
      @client.xquery('INSERT INTO users (nickname,realname) VALUES (?,?)', nickname, realname)
    end

    def delete (nickname, realname)
      @client.xquery('DELETE FROM users where nickname = ? and realname = ?', nickname, realname)
    end

    def select_by_nick (nickname)
      reals = []
      @client.xquery("SELECT realname FROM users where nickname = ?", nickname).each do |res|
        reals.push res["realname"]
      end
      reals
    end

    def select_by_real (realname)
      nicks = []
      @client.xquery("SELECT nickname FROM users where realname = ?", realname).each do |res|
        nicks.push res["nickname"]
      end
      nicks
    end

    def run
      @bot.start
    end

  end
end

resolver = NameResolver.new(conf)
resolver.run

