import { buffer, util } from '@kit.ArkTS';
import { Button, promptAction, router } from '@kit.ArkUI';
import 'learnunits/src/main/ets/pages/LearnUnitsMainPage'
import 'passguardlib/src/main/ets/components/PassGuardMainPage'
import request from '@ohos.request';
import { UIAbility } from '@kit.AbilityKit';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private iconStr: ResourceStr = $r("app.media.app_icon")
  private idList: string[] = ['123', '123423', '234234', '2342342', '23423423']

  private customDialogComponentId: number = 0

  @Builder
  loginIdList(loginIdList: string[]) {
    Column() {
      ForEach(loginIdList, (item: string, index) => {
        Column() {
          Row() {
            Row() {
              Text(item)
                .fontSize(14)
                .fontColor($r('sys.color.black'))
                .margin({ left: 20 })
            }
            .layoutWeight(1)
            .onClick(() => {
            })
            Image($r('app.media.login_close_fork'))
              .height(32)
              .aspectRatio(1)
              .padding(10)
              .onClick(() => {
              })
          }
          .height(45 - px2vp(2))
          if (index != loginIdList.length - 1) {
            Divider().height('2px').backgroundColor($r('app.color.login_divider_line'))
          }
        }
        .height(45)
      })
    }
  }

  build() {
    Column() {
      this.buildFunctionItem("跳转密码键盘", ()=> {
        router.pushNamedRoute({name: 'PassGuardMainPage'})
      })
      this.buildFunctionItem("跳转输入弹窗失焦测试页面", () => {
        router.pushUrl({url:"pages/DialogPage"})
      })
      this.buildFunctionItem("跳转WebView测试页面", () => {
        router.pushUrl({url:"pages/WebPage"})
      })
      this.buildFunctionItem("promptAction.openCustomDialog", () => {
        promptAction.openCustomDialog({
          builder:()=> {
            this.customDialogComponent()
          }
        }).then((id)=> {
          this.customDialogComponentId = id;
        })
      })
      this.buildFunctionItem("测试文件下载", ()=> {
        // https://cbankoss.cqrcb.com/private/account/%E5%8D%95%E7%AC%94%E7%94%B5%E5%AD%90%E5%9B%9E%E5%8D%95%E6%89%93%E5%8D%B020241119004030ic9o.png?Expires=1732552831&OSSAccessKeyId=ehwDwSpOhK66fu3M&Signature=LYfr6ywOxudEbundT%2FstN4Hla%2F8%3D&response-cache-control=no-cache
        const url = 'https://test.cqrcb.com/7D77E5C061137-SIT/00000091/1.0.0.100_all/nebula/00000091_1.0.0.100.amr';
        // request.downloadFile(getContext(), {
        //   url: url,
        //   filePath:getContext().cacheDir + "/" + Date.now()
        // }).then(task=> {
        //   task.on("fail",(err)=> {
        //     promptAction.showToast({message: "下载失败 " + err})
        //     console.error("下载失败" + err)
        //   })
        //   task.on("complete", () => {
        //     promptAction.showToast({message: "下载成功"})
        //     console.error("下载成功" )
        //   })
        //   task.on("progress", (progress)=> {
        //     console.warn("progress is " + progress)
        //   })
        // }).catch((error:BusinessError)=> {
        //   console.error("error is " + error)
        //   console.error("error is" + error)
        // })


        http.createHttp()
          .request(url, (error: BusinessError, data: http.HttpResponse) => {
            if (error) {
              promptAction.showToast({
                message: '下载失败',
              })
              return
            }
            if (data.result instanceof ArrayBuffer) {
              let imageBuffer = data.result as ArrayBuffer;
              promptAction.showToast({
                message: '下载成功',
              })
            }
          })

      })

      this.buildFunctionItem("跳转到档单元学习", ()=> {
        router.pushNamedRoute({name:'LearnUnitsMainPage'})
      })
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  buildFunctionItem(title:string, callback:Function) {
    Button(title)
      .id(title)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .onClick((e)=> callback())
      .margin({top:10})
  }

  @Builder
  customDialogComponent() {
    Column() {
      Text('弹窗').fontSize(30)
      Row({ space: 50 }) {
        Button("确认").onClick(() => {
          promptAction.closeCustomDialog(this.customDialogComponentId)
        })
        Button("取消").onClick(() => {
          promptAction.closeCustomDialog(this.customDialogComponentId)
        })
      }
    }.height(200).padding(5).justifyContent(FlexAlign.SpaceBetween)
  }

  stringTransfer() {
    let str = "7897sdfhjskdhfsjdasdakjsd";
    // 先将string转为uint8Array
    let arrayBuffer = buffer.from(str, 'utf-8').buffer
    let hexStr = arrayBufferToHexStr(arrayBuffer)
    let uint8Array = HexStrToUint8Array(hexStr)
    console.error(new util.TextDecoder().decodeWithStream(uint8Array))
  }

}

/**
 * 将ArrayBuffer的body转为16进制的字符串
 */
function arrayBufferToHexStr(buf: ArrayBuffer):string {
  let data = new Uint8Array(buf)
  let hexString = ''
  for (let i = 0; i < data.length; i++) {
    let char = ('00' + data[i].toString(16)).slice(-2);
    hexString += char
  }
  return hexString
}

function HexStrToUint8Array(data: string): Uint8Array {
  return new Uint8Array(buffer.from(data, 'hex').buffer);
}