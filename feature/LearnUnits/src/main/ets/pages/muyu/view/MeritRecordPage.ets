import { AppBar } from "../../../components/AppBar"
import { MeritRecord } from "../model/MeritRecord"

@Component
export struct MeritRecordPage {
  @State records: MeritRecord[] = []
  @Consume('NavPathStack') pageStack: NavPathStack

  @Builder
  leading() {
    Button() {
      SymbolGlyph($r('sys.symbol.chevron_left')).fontSize(28)
        .fontColor([Color.Black])
    }.width(36).height(36).backgroundColor(Color.Transparent)
    .onClick(() => {
      this.pageStack.pop()
    })
  }

  @Builder
  titleBuilder() {
    Text("功德记录")
      .fontSize('18fp').fontWeight(FontWeight.Bold)
  }

  @Builder
  tailingBuilder() {
    Text("")
      .fontSize(20).fontWeight(FontWeight.Bold)
  }

  build() {
    NavDestination() {
      AppBar({
        bgColor: Color.White,
        titleSolt: this.titleBuilder,
        leading: () => {
          this.leading()
        },
      })
      Column() {
        List() {
          ForEach(this.records, (record: MeritRecord, index) => {
            MeritRecordItem({ record: record })
          }, (item: MeritRecord) => `${item.timestamp}`)
        }
      }.height('100%').width('100%')
      .alignItems(HorizontalAlign.Center)
    }.onReady((ctx) => this.buildParam(ctx))
    .hideTitleBar(true)
  }

  buildParam(context: NavDestinationContext): void {
    this.records = context.pathInfo.param as MeritRecord[]
  }
}

@Component
struct MeritRecordItem {
  record: MeritRecord = new MeritRecord({
    timestamp: Date.now(),
    value: 1,
    image: $r('app.media.muyu2'),
    audio: '空灵弥音'
  })

  build() {
    Row() {
      Image(this.record.image)
        .width(48)
        .height(48)
        .padding(6)
        .margin({ left: 12, right: 12 })
        .borderRadius(24)
        .backgroundColor('#2c85d6')

      Column() {
        Text(`功德 +${this.record.value}`).fontSize(16).margin({ bottom: 4 })
        Text(this.record.audio).fontSize(12).fontColor(Color.Gray)
      }.layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text(`${new Date(this.record.timestamp).toLocaleString()}`).fontSize(12).margin({ right: 12 })
    }.padding(6).width('100%').justifyContent(FlexAlign.Start)
  }
}


@Builder
export function pageBuilder() {
  MeritRecordPage()
}