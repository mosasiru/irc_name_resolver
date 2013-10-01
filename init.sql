use irc_resolver;

CREATE TABLE `users` (
  `realname` varchar(20) NOT NULL,
  `nickname` varchar(20) NOT NULL,
  PRIMARY KEY (`nickname`,`realname`),
  KEY `realname` (`realname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
