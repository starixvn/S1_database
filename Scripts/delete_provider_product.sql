

update TpList
	set Status = 0 
WHERE id not in (71,72,73,61,66,67,68,69,32,55,5,5,14,18,15,12,41);

update TpList
	set TpName = 'AESexy'
		,Displayname = 'AE Sexy'
where id = 15;

update TpList
	set TpName = 'WE'
		,Displayname = 'World Entertainment'
where id = 18;

update TpList
	set Displayname = 'SABASports'
where id = 41;


-- TpCategory
update TpCategory 
	set Status = 0
WHERE id not in (1,2,3,6,7,10);


update TpCategory
	set name = 'Slots'
where id = 2;

delete
from TpGameType
where Type not in (124,125,126,113,119,120,121,122,53,106,16,7,17,28,18,6,69,70,71,72);

-- SiteConfig
update SiteConfig
	set configkey = 'AESexy'
where ConfigGroup = 'TP'
and configkey = 'Sexy';

update SiteConfig
	set configkey = 'WE'
where ConfigGroup = 'TP'
and configkey = 'EBet';


update TpGameType
	set typename = 'MaxGame'
where type = 113;

update TpGameType
	set typename = 'SabaPlay'
where type = 119;

update TpGameType
	set typename = 'WE L.Casino'
where type = 28;


update TpGameType
	set typename = 'AE Sexy L.Casino'
where type = 18;