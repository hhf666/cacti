--
-- Enable rrdtool from docker installation
--

REPLACE INTO `%DB_NAME%`.`settings` (`name`, `value`) VALUES('path_rrdtool', '/usr/local/rrdtool/bin/rrdtool');
