import { buffer, util } from '@kit.ArkTS';
import { Button, router } from '@kit.ArkUI';
import '@feature/passguardlib/src/main/ets/components/PassGuardMainPage'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private iconStr: ResourceStr = $r("app.media.app_icon")
  private idList: string[] = ['123', '123423', '234234', '2342342', '23423423']

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