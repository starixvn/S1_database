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
PRIMARY KEY (`SQ`) )
ENGINE=InnoDB AUTO_INCREMENT=202411000039029 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SBSW Payload (Seamless Request記錄)'


INSERT INTO auto_gen_tablelist (table_schema, table_name, create_interval, adjust_increment_start)
VALUES('TSDB', 'Bettrans_SBSW_Payload', 'Monthly',1);