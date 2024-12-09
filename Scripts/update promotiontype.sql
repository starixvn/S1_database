/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="" isFunction="0" isNested="0"></info>*/

   update PromotionType
      set isnew = 0
	where type not in (2,1)