
import web_webview from '@ohos.web.webview'
import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';


@Entry({routeName: 'GMSSLDemoPage'})
@Component
struct GMSSLDemoPage {
  @State message: string = '微通新成鸿蒙国密SSL演示Demo';
  @State httpMessage: string = '当前未发请求';
  webcontroller: web_webview.WebviewController = new web_webview.WebviewController()

  aboutToAppear(): void {

  }

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.message)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }

      Blank().height('5%')
      Row() {

        Button('国密SSL-Webview加载页面刷新').fontSize(10).onClick(() => {
          this.webcontroller.refresh();
        })
      }

      Web({ src: 'https://127.0.0.1:8899/boc15/index.html', controller: this.webcontroller })
        .onSslErrorEventReceive((event) => {
          event.handler.handleConfirm();
        })
        .height('40%')
        .backgroundColor(Color.Green)
      Blank().height(10);
      Button('ohos.net.http Request请求数据(支持header传入TargetIPPORT\r\n传入优先级高于OHGmSslSetTargetIPPort)').height(80).fontSize(10).onClick(() => {

        class Header {
          public TargetIPPORT: string;

          constructor(TargetIPPORT: string) {
            this.TargetIPPORT = TargetIPPORT;
          }
        }
        // 每一个httpRequest对应一个HTTP请求任务，不可复用
        let httpRequest = http.createHttp();
        // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
        // 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
        httpRequest.on('headersReceive', (header) => {
          console.info('header: ' + JSON.stringify(header));
        });
        httpRequest.request(// 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
          // "https://127.0.0.1:8899/boc15/index.html",
          "https://127.0.0.1:8899/",
          {
            method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
            // 开发者根据自身业务需要添加header字段
            header: new Header('commobibank.bankofbeijing.com.cn:30013'),
            // 当使用POST请求时此字段用于传递内容
            // extraData: "data to send",
            // expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
            usingCache: true, // 可选，默认为true
            priority: 1, // 可选，默认为1
            connectTimeout: 60000, // 可选，默认为60000ms
            readTimeout: 60000, // 可选，默认为60000ms
            // usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
            // usingProxy: true, //可选，默认不使用网络代理，自API 10开始支持该属性
            caPath: getContext().filesDir + "/wtSSL.pem"
          }, (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            // data.result为HTTP响应内容，可根据业务需要进行解析
            console.info('###Result:' + data.result);
            console.info('###code:' + JSON.stringify(data.responseCode));
            // data.header为HTTP响应头，可根据业务需要进行解析
            console.info('###header:' + JSON.stringify(data.header));
            console.info('###cookies:' + JSON.stringify(data.cookies)); // 8+
            // 当该请求使用完毕时，调用destroy方法主动销毁
            this.httpMessage = "httpCode:" + JSON.stringify(data.responseCode) + "\r\n" + data.result.toString();
            httpRequest.destroy();
          } else {
            console.error('error:' + JSON.stringify(err));
            // 取消订阅HTTP响应头事件
            httpRequest.off('headersReceive');
            // 当该请求使用完毕时，调用destroy方法主动销毁
            httpRequest.destroy();
          }
        }
        );
      })
      Blank().height(10);
      Text(this.httpMessage)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.Yellow)
    }

  }
}