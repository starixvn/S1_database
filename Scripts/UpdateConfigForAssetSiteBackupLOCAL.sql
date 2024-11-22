/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: Update SiteConfig for backup asset site
*/

update SiteConfig set ConfigValue = '
{
     "OldImageUrl": "https://minio-api.lumigame.com/s1-gameimgs",
     "MaintainUrl": "https://error.0814media.net/tp",
     "HotEventImageUrl": "https://sportsimgs.0814media.net",
     "BannerImageUrl": "https://s1-static-back-up.nexdev.net",
     "AwsCloudFrontErrorDomainID": "E1YRMI432N93BB",
     "UploadImagesBucketName": "s1-banner",
     "UploadImagesCloudFrontUrl": "https://minio-api.lumigame.com/s1-banner",
     "UploadSlotImagesBucketName": "s1-gameimgs",
     "AwsCloudFrontGameimgsDomainID": "E1D231IBGA3ESP"
  }'
where configType = 'AWS' and siteId = 0 and ConfigKey='SiteCloudFrontImageInfo'


update SiteConfig set ConfigValue = '
{
"BannerDomain":"s1-static-back-up.nexdev.net",
"PaymentDomain":"s1-static-back-up.nexdev.net/paymentlogo",
"ImgDomain":"minio-api.lumigame.com/s1-gameimgs",
"SportImgDomain":"s1-static-back-up.nexdev.net/sports"}'
where configType = 'StaticFileDomain' and siteId = 0 and ConfigKey='StaticFileDomain'