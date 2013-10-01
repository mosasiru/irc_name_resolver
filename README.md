#USAGE

on your IRC client,

```
register Ben Benjamin
# inr_bot "registerd: nick(Ben) => real(Benjamin)"

register Benny Benjamin
# inr_bot "registerd: nick(Benny) => real(Benjamin)"

nick? Benjamin
# inr_bot: "Benjamin's nickname: Ben,Benny"

real? mosa  # yusuke.enomoto
# inr_bot: "Ben's realname: Benjamin"

unregister Ben Benjamin
# inr_bot: "unregistered: nick(Ben) => real(Benjamin)"

ping
# inr_bot: "pong"

how
# show usage.

```

you can register multipul nicknames to one realname.

#INSTALATION

```
bundle install
mysql -u {admin} -p{password} < init.sql
```

modify config.yaml.

#RUN

```
ruby run.rb
```
