require 'mysql2-cs-bind'

#client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "", :database => "irc_resolver")

#client.xquery('INSERT INTO users (nickname,realname) VALUES (?,?)', 1, 2)

#client.xquery("SELECT nickname FROM users where id = ?", 3).each do |res|
  #p res
#end

class NameResolver

  def initialize()
    @client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "", :database => "irc_resolver")


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

    def insert (nickname, realname)
      @client.xquery('INSERT INTO users (nickname,realname) VALUES (?,?)', nickname, realname)
    end

    def delete (nickname, realname)
      @client.xquery('DELETE FROM users where nickname = ? and realname = ?', nickname, realname).each do |res|
        p res
      end
    end

  end
end

resolver = NameResolver.new()
p resolver.insert('nick','real1')
p resolver.delete('nick','real1')
p resolver.select_by_real('real1')

