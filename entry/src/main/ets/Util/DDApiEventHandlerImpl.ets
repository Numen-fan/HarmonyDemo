import { BaseResp, IDDAPIEventHandler, BaseReq, SendMessageToDD, ErrCode, DDShareApi } from "@dingtalk/ddsharesdk"
import { promptAction } from '@kit.ArkUI';

export class DDApiEventHandlerImpl implements IDDAPIEventHandler {

  onReq(req: BaseReq): void {
    console.log("testTag 来自钉钉的请求")
  }

  onResp(resp: BaseResp): void {
    let errCode = resp.mErrCode;
    console.log("testTag 来自钉钉的响应:", JSON.stringify(resp));
    if (resp instanceof SendMessageToDD.Resp) {
      switch (errCode) {
        case ErrCode.ERR_OK:
          promptAction.showToast({
            message: "分享成功",
            duration: 2000
          })
        break;
        case ErrCode.ERR_USER_CANCEL:
          promptAction.showToast({
            message: "分享取消",
            duration: 2000
          })
          break;
        default :
          promptAction.showToast({
            message: "分享失败",
            duration: 2000
          })
          break;
      }
    }
  }
}

/**
 * 在钉钉开放平台申请的应用AppKey
 * 替换为自己的
 */
export const APP_ID: string = "123";
export const DDApi = DDShareApi.getInstance(APP_ID);
export const DDEventHandle = new DDApiEventHandlerImpl();
