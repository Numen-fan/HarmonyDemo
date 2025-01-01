import { AppBar } from "../../../components/AppBar"
import { MuyuBloc } from "../bloc/MuyuBloc"
import { AnimaValueView } from "./AnimaValueView"
import { MeritRecordPage } from "./MeritRecordPage"
import { MySelectorSheet } from "./MuyuSelectorSheet"
import { VoiceSelectorSheet } from "./VoiceSelectorSheet"

@Component
export struct MuyuPage {
  @State model: MuyuBloc = new MuyuBloc()
  @State isShowSheet: boolean = false
  @State isMusicSelected: boolean = false
  @Consume('NavPathStack') pageStack: NavPathStack

  build() {
    NavDestination() {
      Column() {
        this.appBar()
        this.valueDisplay()
        this.muyuDisplay()
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fafaaf')
      .bindSheet($$this.isShowSheet, this.sheetBuilder(), {
        height: 400,
        showClose: false
      })
    }.hideTitleBar(true)
  }

  aboutToDisappear(): void {
    this.model.release()
  }

  @Builder
  appBar() {
    AppBar({
      bgColor: '#fafaaf',
      leading: this.title,
      tailing: () => {
        this.tailing()
      }
    })
  }

  @Builder
  valueDisplay() {
    Stack() {
      Column() {
        Text(`功德数：${this.model.counter}`).fontWeight(FontWeight.Bold).fontSize('24fp')
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // 右上角的按钮
      this.buildButtons()
    }.layoutWeight(1)
    .width('100%')
  }

  @Builder
  muyuDisplay() {
    Stack() {
      Column() {
        Image(this.model.imageSrc()).width(200)
          .onClick(() => {
            this.model.tick()
          })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // 记住这里一定要将counter传参
      AnimaValueView({ counter: this.model.counter })
    }
    .layoutWeight(1)
    .width('100%')
  }

  @Builder
  buildButtons() {
    Column() {
      Button({ type: ButtonType.Normal, stateEffect: true }) {
        SymbolGlyph($r('sys.symbol.music_fill'))
          .fontSize(20)
          .fontColor([Color.White])
          .fontWeight(FontWeight.Bold)
      }
      .margin({ bottom: 12 })
      .width(36)
      .height(36)
      .borderRadius(4)
      .onClick(() => {
        this.showSelectorSheet(true)
      })

      Button({ type: ButtonType.Normal, stateEffect: true }) {
        SymbolGlyph($r('sys.symbol.picture_fill'))
          .fontSize(20)
          .fontColor([Color.White])
          .fontWeight(FontWeight.Bold)
      }.width(36).height(36).borderRadius(4)
    }.position({
      top: 12, right: 12
    }).onClick(() => {
      this.showSelectorSheet(false)
    })
  }

  @Builder
  title() {
    Text("电子木鱼").fontSize('18fp').layoutWeight(FontWeight.Bold).margin({ left: 12 })
  }

  @Builder
  tailing() {
    Button() {
      Image($r('app.media.history')).width(26).height(26).fillColor(Color.Black)
    }.width(36).height(36).backgroundColor(Color.Transparent)
    .onClick(() => {
      this.toHistory()
    })
  }

  @Builder
  sheetBuilder() {
    Column() {
      if (this.isMusicSelected) {
        VoiceSelectorSheet({
          activeIndex: this.model.activeAudioIndex,
          options: this.model.audioOptions,
          onPreview: (index) => {
            this.model.previewAudio(index)
          },
          onSelected: (index) => {
            this.isShowSheet = false
            this.model.changeVoice(index)
          }
        })
      } else {
        MySelectorSheet({
          activeIndex: this.model.activeImageIndex,
          options: this.model.imageOptions,
          onSelected: (index) => {
            this.isShowSheet = false // 返回按钮，或者点击空白，sheet也会消失啊（双向绑定的）
            this.model.changeImage(index)
          }
        })
      }
    }
  }

  showSelectorSheet(isMusic: boolean) {
    this.isMusicSelected = isMusic
    this.isShowSheet = true
  }

  toHistory() {
    this.pageStack.pushPathByName('merit_record', this.model.records.reverse())
  }
}

@Builder
export function pageBuilder() {
  MuyuPage()
}