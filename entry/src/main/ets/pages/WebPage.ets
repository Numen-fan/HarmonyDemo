import { webview } from '@kit.ArkWeb';

@Preview
@Entry
@Component
struct WebPage {
  controller: webview.WebviewController = new webview.WebviewController();
  // 配置Web开启调试模式
  @State visiableTips: string = ""

  aboutToAppear(): void {
    webview.WebviewController.setWebDebuggingAccess(true)
  }

  build() {
    Column() {
      Text(this.visiableTips)
      Web({
        src: 'https://cbankoss.cqrcb.com/private/account/%E5%8D%95%E7%AC%94%E7%94%B5%E5%AD%90%E5%9B%9E%E5%8D%95%E6%89%93%E5%8D%B020241119004030ic9o.png?Expires=1732552831&OSSAccessKeyId=ehwDwSpOhK66fu3M&Signature=LYfr6ywOxudEbundT%2FstN4Hla%2F8%3D&response-cache-control=no-cache',
        controller: this.controller
      })
        .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
          console.info('Test Text isVisible: ' + isVisible + ', currentRatio:' + currentRatio)
          if (isVisible && currentRatio >= 1.0) {
            console.info('Test Text is fully visible. currentRatio:' + currentRatio)
            this.visiableTips = 'Test Text is fully visible'
          }
          if (!isVisible && currentRatio <= 0.0) {
            console.info('Test Text is completely invisible.')
            this.visiableTips = 'Test Text is completely invisible'
          }
        })
        .onErrorReceive((event) => {
          if (event) {
            console.log('getErrorInfo:' + event.error.getErrorInfo());
            console.log('getErrorCode:' + event.error.getErrorCode());
            console.log('url:' + event.request.getRequestUrl());
            console.log('isMainFrame:' + event.request.isMainFrame());
            console.log('isRedirect:' + event.request.isRedirect());
            console.log('isRequestGesture:' + event.request.isRequestGesture());
            console.log('getRequestHeader_headerKey:' + event.request.getRequestHeader().toString());
            let result = event.request.getRequestHeader();
            console.log('The request header result size is ' + result.length);
            for (let i of result) {
              console.log('The request header key is : ' + i.headerKey + ', value is : ' + i.headerValue);
            }
          }
        })
        .fileAccess(true)
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .onlineImageAccess(true)
        .onControllerAttached(() => {
          console.log("onControllerAttached");
          try {
            let userAgent = "Mozilla/5.0 (Phone; Android 5.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36  ArkWeb/4.1.6.1 Mobile"
            console.log(userAgent);
            this.controller.setCustomUserAgent(userAgent);
          } catch (error) {
            console.error(`ErrorCode:`);
          }
        })
        .width("100%")
        .height("100%")
    }
  }
}