DROP USER IF EXISTS 'sadmin'@'localhost';
DROP USER IF EXISTS 'organizer'@'%';
DROP USER IF EXISTS 'suser'@'%';

CREATE USER 'organizer'@'%' IDENTIFIED BY 'organizerpass';
GRANT SELECT ON mydb.* TO 'organizer'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.user TO 'organizer'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.athlete TO 'organizer'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.tournament TO 'organizer'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.athlete_plays_match TO 'organizer'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.pair_plays_match TO 'organizer'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.match TO 'organizer'@'%';

CREATE USER 'suser'@'%' IDENTIFIED BY 'userpass';
GRANT SELECT ON mydb.* TO 'suser'@'%';
GRANT UPDATE, DELETE ON mydb.`user` TO 'suser'@'%';
GRANT UPDATE, DELETE ON mydb.coach TO 'suser'@'%';
GRANT UPDATE, DELETE ON mydb.referee TO 'suser'@'%';
GRANT UPDATE, DELETE ON mydb.athlete TO 'suser'@'%';
GRANT UPDATE, DELETE ON mydb.sponsor TO 'suser'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.match TO 'suser'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.tournament TO 'suser'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.pair TO 'suser'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.pair_plays_match TO 'suser'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.athlete_plays_match TO 'suser'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.pair_has_athlete TO 'suser'@'%';
GRANT INSERT, UPDATE, DELETE ON mydb.sfyraei TO 'suser'@'%'; 

CREATE USER 'sadmin'@'localhost' IDENTIFIED BY 'superpass';
GRANT ALL PRIVILEGES ON mydb.* TO 'sadmin'@'localhost';