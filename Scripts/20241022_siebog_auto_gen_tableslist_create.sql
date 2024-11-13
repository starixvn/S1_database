/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241112@Luke
	DB: TSDB-TSDB
	Task: create table auto_gen_tablelist
*/
CREATE TABLE Siebog.auto_gen_tablelist (
  `table_schema` varchar(20) NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `table_definition` text,
  `create_interval` varchar(20) NOT NULL,
  PRIMARY KEY (`table_schema`,`table_name`,`create_interval`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
