import { AppBar } from "../components/AppBar"

@Component
export struct SettingPage {
  @Consume('NavPathStack') pageStack: NavPathStack
  @StorageLink('randomNum') randomNum: number = 0

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
      Column() {
        this.appBar()
        Row() {
          Text("随机点数")
          TextInput({ text: this.randomNum.toString() })
            .onChange((value) => {
              this.randomNum = Number(value)
            })
            .type(InputType.Number)
            .margin({ left: 10 })
        }
        .width('100%')
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