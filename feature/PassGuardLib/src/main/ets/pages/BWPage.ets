import {
  OHTxLic,
  OHTxcDecryptR0EnStr,
  OHTxcSetJSExternalPublicKey,
  OHTxcEncryptByECBAndHMac,
  OHTxcEncryptByECBAndHMacNoRCCipher,
  OHTxcDecryptByECBAnCheckHmac
} from '@ohos/libPassGuardSDK';

@Entry({routeName: 'BWPage'})
@Entry
@Component
struct BWPage {
  @State tipsTxt: string = "";

  build() {
    Column() {
      Row() {
        Button('报文lic').onClick(() => {
          this.tipsTxt = "报文lic(正确返回1001 生产 1000 测试):"+OHTxLic("TVU3VUd2bWw3ckI1VmRraDdHU2hkU0lXQzRpQUVyMnZnNm0vU09ENkdGY1ZycnBiT2w2a0E0QXdYZE1CKzd5dnV0ZStGWGE0M0ZtaERadjdNS0NMRE9vRFR2aGVYcWRyUW45akhXdlFyTVVySkpzZTRWVFRuMmwyeTQ4SUp5Tmh6dmppYSt3Yi9wdDZJNDFCbnUrMDRoOGYwc0NVSi9jWXhDWG1CRFdTa3ZvPXsiaWQiOjEsInR5cGUiOiJ0ZXN0IiwicGxhdGZvcm0iOjMsIm5vdGJlZm9yZSI6IjIwMjQwNDE4Iiwibm90YWZ0ZXIiOiIyMDI0MDcxOCJ9");
        })
        Button('R0+PK').onClick(() => {
          let ret0 = OHTxcDecryptR0EnStr("NDM0MjQ1MzI0MTMyMzg0NDMwMzk0NDM4MzY0MjQ2NDIzNTM0MzI0NDQ2MzIzMTM1NDQzMDMxNDYzNDM4NDU0MT4s7TF5c+P/iMB30AO+5RazxU5Wm1heuolBcnFOj4TsEAsHoSUuQQRECPxli0+fAnD68LsHPSl3qxSt1sHKBeZvLBhvUqBT1HWFCPpO6o8n");
          console.log("###OHTxcDecryptR0EnStr:" + ret0);
          this.tipsTxt = this.tipsTxt+"\r\nOHTxcDecryptR0EnStr:" +ret0
          OHTxcSetJSExternalPublicKey("1093A047C5CBF48283EC7A210703F3FF9EA4448DC15D56B4CD82FCB27DAD2D45F2BB0BF953BCEBB635D9D34E473ECEFC9F25880EB1669F94DE050A29AC86F308");
        })
        Button('enc+dec').onClick(() => {
          let ret1 = OHTxcEncryptByECBAndHMac("123Abc天安门￥%……&*");
          this.tipsTxt = this.tipsTxt+"\r\nHTxcEncryptByECBAndHMac:" +ret1
          console.log("###OHTxcEncryptByECBAndHMac:" + ret1);

          // let ret2 = OHTxcDecryptByECBAnCheckHmac('服务端数据');
          // console.log("###OHTxcDecryptByECBAnCheckHmac:" + ret2);
          // this.tipsTxt = this.tipsTxt+"\r\nOHTxcDecryptByECBAnCheckHmac:" +ret2
        })
        Blank().height(10)

      }.alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })

      Text(this.tipsTxt).fontSize(10);
    }
    .height('100%')
    .width('100%')
  }
}