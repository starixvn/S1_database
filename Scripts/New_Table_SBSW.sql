/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
 /*Created: 20241031@Los
	DB: TSDB-TSDB
	Task: Create table Bettrans_SBSW_Payload_XXXX

	Revisions:
        - 20241119@Los: Initial
*/ 
CREATE TABLE `Bettrans_SBSW_Payload_202411` (
`SQ` bigint NOT NULL AUTO_INCREMENT,
`Timestamp` varchar(64) NOT NULL, 
`Seq` varchar(64) NOT NULL,
`Payload` json NOT NULL,
`CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
`UpdateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
`Action` varchar(50) DEFAULT NULL,
`GameType` varchar(50) DEFAULT NULL,
`environment` varchar(20) DEFAULT NULL,
`Response` json DEFAULT NULL,
PRIMARY KEY (`SQ`)
)
ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SBSW Payload (Seamless Request記錄)'


INSERT INTO auto_gen_tablelist (table_schema, table_name, create_interval, adjust_increment_start)
VALUES('TSDB', 'Bettrans_SBSW_Payload', 'Monthly',1);