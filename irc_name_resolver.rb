require 'cinch'

class IRCNameResolver

  def initialize(config, mysql_client)
    @mysql_client = mysql_client

    @bot = Cinch::Bot.new do

      configure do |c|
        c.server    = config[:server]
        c.channels  = config[:channels]
        c.nick      = config[:nick]
        c.realname  = config[:realname]
        c.user      = config[:user]
      end

      on :message, /^register/ do |m|
        (command, nickname, realname) = m.message.split("\s")
        if mysql_client.insert(nickname, realname)
          m.reply("registerd: nick(#{nickname}) => real(#{realname})")
        else
          m.reply("already registerd: nick(#{nickname}) => real(#{realname})")
        end
      end

      on :message, /^unregister/ do |m|
        (command, nickname, realname) = m.message.split("\s")
        if mysql_client.delete(nickname, realname)
          m.reply("unregistered: nick(#{nickname}) => real(#{realname})")
        else
          m.reply("not exists: nick(#{nickname}) => real(#{realname})")

        end
      end

      on :message, /^nick\?/ do |m|
        (command, realname) = m.message.split("\s")
        nicknames =  mysql_client.select_by_real(realname)
        if nicknames.empty?
          m.reply("#{realname} is not registerd.")
        else
          m.reply("#{realname}'s nickname: #{nicknames.join(',')}")
        end
      end

      on :message, /^real\?/ do |m|
        (command, nickname) = m.message.split("\s")
        realnames = mysql_client.select_by_nick(nickname)
        if realnames.empty?
          m.reply("#{nickname} is not registerd.")
        else
          m.reply("#{nickname}'s realname: #{realnames.join(',')}")
        end
      end

      on :message, /^how$/ do |m|
        m.reply("usage: https://github.com/mosasiru/irc_name_resolver")
      end

      on :message, /^ping$/ do |m|
        m.reply("pong")
      end
    end

    def run
      @bot.start
    end

  end
end


