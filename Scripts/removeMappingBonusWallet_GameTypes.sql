/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="" isFunction="0" isNested="0"></info>*/

delete from PromotionCategoryGameType where promotioncategoryid in (11,6,12,13,14,15);
delete from PromotionCategory where id in (11,6,12,13,14,15);
update PromotionCategory set name = 'ALL' where id = 0;

delete from PromotionCategoryGameType
where promotioncategoryid in (0,1) and gametype in (53,56)


delete from PromotionCategoryGameType
where gametype in (70,71,72)