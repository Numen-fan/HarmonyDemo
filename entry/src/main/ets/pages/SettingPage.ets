import { AppBar } from "../components/AppBar"
import { promptAction } from "@kit.ArkUI"

@Component
@Preview
export struct SettingPage {
  @Consume('NavPathStack') pageStack: NavPathStack
  @StorageLink('randomNum') randomNum: number = 0
  @StorageLink('preferSearch') preferSearch: string = ''

  @Builder
  title() {
    Text('设置').fontSize('18fp').fontWeight(FontWeight.Bold).margin({ left: 12 })
  }

  @Builder
  backButton() {
    Button() {
      SymbolGlyph($r('sys.symbol.chevron_left')).fontSize(28)
        .fontColor([Color.Black])
    }.width(36).height(36).backgroundColor(Color.Transparent)
    .onClick(() => {
      this.pageStack.pop()
    })
  }

  @Builder
  appBar() {
    AppBar({
      titleSolt: this.title,
      leading: () => {
        this.backButton()
      },
      bgColor: Color.White
    })
  }

  build() {
    NavDestination() {
      Column({ space: 10 }) {
        this.appBar()
        Row() {
          Text("随机生成点数")
          TextInput({ text: this.randomNum.toString() })
            .onChange((value) => {
              this.randomNum = Number(value)
            })
            .type(InputType.Number)
            .margin({ left: 10 })
            .layoutWeight(1)
        }

        Row() {
          Text("添加常用搜索")
          TextInput({ placeholder: "请输入地点" })
            .enterKeyType(EnterKeyType.Done)
            .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
              let value = event.text
              if (value.length < 1 || this.preferSearch.indexOf(value) >= 0) {
                return
              }
              this.preferSearch += `|${value}`
              promptAction.showToast({ message: "添加成功" })
            })
            .margin({ left: 10 })
            .layoutWeight(1)
        }
      }.height('100%')
      .width('100%')
      .padding(10)
    }.hideTitleBar(true)
  }
}


@Builder
export function pageBuilder() {
  SettingPage()
}