create user 'debezium'@'%' identified by 'password';
grant select, reload, show databases, replication slave, replication client on *.*
  to 'debezium'@'%' identified by 'password';
