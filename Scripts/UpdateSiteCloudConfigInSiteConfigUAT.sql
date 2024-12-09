/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: Update SiteCloudFrontImageInfo in SiteConfig table UAT
*/

update SiteConfig set ConfigValue = '
{"OldImageUrl":"https://minio-api.vgamesuat.com/s1-gameimgs",
"MaintainUrl":"https://minio-api.vgamesuat.com/s1-errorpage",
"HotEventImageUrl": "https://minio-api.vgamesuat.com/s1-sportsimgs",
"BannerImageUrl": "https://assets.vgamesuat.com",
"UploadImagesBucketName": "s1-banner",
"UploadImagesCloudFrontUrl": "https://minio-api.vgamesuat.com/s1-banner",
"UploadSlotImagesBucketName": "s1-gameimgs"}'
where configType = 'AWS' and siteId = 0 and ConfigKey='SiteCloudFrontImageInfo'