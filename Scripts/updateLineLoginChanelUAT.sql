/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: update line config UAT
*/

update SiteConfig set ConfigValue = '{
 		  "ChannelId": "2006584232",
 		  "ChannelSecret": "2789535a8e5834be55a19926661df481",
 		  "ExpiredSeconds": 300
 	  	}'
where configType = 'Line' and siteId = 0 and ConfigKey='LineLoginChannelConfig.UAT.json'