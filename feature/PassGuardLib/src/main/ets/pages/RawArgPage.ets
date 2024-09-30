import {
  OHTxLic,
  ohGmRSM2Encrypt,
  ohGmRSM2Decrypt,
  ohGmRSM2Sign,
  ohGmRSM2Verify,
  ohGmRSM3,
  ohGmRSM3HMac,
  ohGmRSM4Encrypt,
  ohGmRSM4Decrypt
} from '@ohos/libPassGuardSDK';

@Entry({routeName: 'RawArgPage'})
@Component
struct RawArgPage {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Button('点击控制台查看算法调用演示').onClick(() => {
        OHTxLic("TVU3VUd2bWw3ckI1VmRraDdHU2hkU0lXQzRpQUVyMnZnNm0vU09ENkdGY1ZycnBiT2w2a0E0QXdYZE1CKzd5dnV0ZStGWGE0M0ZtaERadjdNS0NMRE9vRFR2aGVYcWRyUW45akhXdlFyTVVySkpzZTRWVFRuMmwyeTQ4SUp5Tmh6dmppYSt3Yi9wdDZJNDFCbnUrMDRoOGYwc0NVSi9jWXhDWG1CRFdTa3ZvPXsiaWQiOjEsInR5cGUiOiJ0ZXN0IiwicGxhdGZvcm0iOjMsIm5vdGJlZm9yZSI6IjIwMjQwNDE4Iiwibm90YWZ0ZXIiOiIyMDI0MDcxOCJ9");

        let sm2Enc = ohGmRSM2Encrypt("1867c18eb322fac7959fc076842aaf816c369919", "1093A047C5CBF48283EC7A210703F3FF9EA4448DC15D56B4CD82FCB27DAD2D45",
          "F2BB0BF953BCEBB635D9D34E473ECEFC9F25880EB1669F94DE050A29AC86F308", 2,0);
        console.log("###ohGmRSM2Encrypt:" + sm2Enc);
        let sm2Dec = ohGmRSM2Decrypt(sm2Enc, "52204091D6714B220A7BA049A96A300F043BB9A0BD238408FFDD330AA0D2FCC5", 2,0);
        console.log("###ohGmRSM2Decrypt:" + sm2Dec);
        let sm2Sign = ohGmRSM2Sign("313233343536", "52204091D6714B220A7BA049A96A300F043BB9A0BD238408FFDD330AA0D2FCC5", 0,1,1);
        console.log("###ohGmRSM2Sign:" + sm2Sign);
        let sm2VSign =
          ohGmRSM2Verify("313233343536", sm2Sign, "1093A047C5CBF48283EC7A210703F3FF9EA4448DC15D56B4CD82FCB27DAD2D45",
            "F2BB0BF953BCEBB635D9D34E473ECEFC9F25880EB1669F94DE050A29AC86F308", 0,1,1);
        console.log("###ohGmRSM2Verify:" + sm2VSign);
        let sm3Hash = ohGmRSM3("123456", 0);
        console.log("###sm3Hash:" + sm3Hash);
        let sm3HashHMac = ohGmRSM3HMac("yangbing", "016075ee48bf33497360a48a5cd07fbb", 0);
        console.log("###ohGmRSM3HMac:" + sm3HashHMac +
          ",预期结果:43c612a10ce6259644c876bd3f08dfc35d0e12f3005b99953b34a6b9e66007fd");

        //ECB
        {
          let sm4Enc =
            ohGmRSM4Encrypt("1234567890123456", "1234567890123456", "12345678901234561234567890123456", 0, 2, 0, 0, 0);
          console.log("###ohGmRSM4Encrypt:" + sm4Enc);
          let sm4Dec = ohGmRSM4Decrypt("1234567890123456", "1234567890123456", sm4Enc, 0, 2, 0, 0, 0);
          console.log("###ohGmRSM4Decrypt:" + sm4Dec);
        }

        //CBC
        {
          let sm4Enc =
            ohGmRSM4Encrypt("1234567890123456", "1234567890123456", "12345678901234561234567890123456", 1, 2, 0, 0, 0);
          console.log("###ohGmRSM4Encrypt-CBC:" + sm4Enc);
          let sm4Dec = ohGmRSM4Decrypt("1234567890123456", "1234567890123456", sm4Enc, 1, 2, 0, 0, 0);
          console.log("###ohGmRSM4Decrypt-CBC:" + sm4Dec);
        }


      })


    }
    .height('100%')
    .width('100%')
    .align(Alignment.Center)
  }
}
