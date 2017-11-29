--
-- Enable spine poller from docker installation
--

REPLACE INTO `%DB_NAME%`.`settings` (`name`, `value`) VALUES('path_spine', '/usr/local/spine/bin/spine');
REPLACE INTO `%DB_NAME%`.`settings` (`name`, `value`) VALUES('path_spine_config', '/usr/local/spine/etc/spine.conf');
REPLACE INTO `%DB_NAME%`.`settings` (`name`, `value`) VALUES('poller_type', '2');
