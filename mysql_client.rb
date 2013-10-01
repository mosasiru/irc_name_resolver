require 'mysql2-cs-bind'

class MySQLClient
  def initialize(config)
    @client = Mysql2::Client.new(
      :host     => config[:host],
      :username => config[:username],
      :password => config[:password],
      :database => config[:database],
    )
  end

  def insert (nickname, realname)
    begin
      @client.xquery('INSERT INTO users (nickname,realname) VALUES (?,?)', nickname, realname)
    rescue
      return false
    end
    true
  end

  def delete (nickname, realname)
    @client.xquery('DELETE FROM users where nickname = ? and realname = ?', nickname, realname)
    @client.affected_rows > 0
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
end

