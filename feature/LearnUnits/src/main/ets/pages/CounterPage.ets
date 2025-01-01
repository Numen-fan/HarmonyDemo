import { AppBar } from "../components/AppBar";

@Component
export struct CounterPage {
  @State counter: number = 0;

  build() {
    Stack() {
      Column() {
        AppBar({title: "计数器", leading:this.leading, tailing:this.tailing})
        Column() {
          Text("以下是你点击的次数")
            .fontSize($r('app.float.counter_desc_size'))
          Text(`${this.counter}`)
            .fontColor('#2e3032')
            .fontSize($r('app.float.counter_value_size'))
            .margin({ top: 10 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }.width('100%')
      .height('100%')

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        SymbolGlyph($r('sys.symbol.plus'))
          .fontSize(24).fontColor([Color.White]).fontWeight(FontWeight.Bold)
      }.onClick(() => {
        this.counter++
      })
      .width(56).height(56).margin({ right: 20, bottom: 20 })
    }.alignContent(Alignment.BottomEnd)
  }

  @Builder
  leading() {
    SymbolGlyph($r('sys.symbol.access_card'))
      .fontSize(24)
      .fontColor([Color.White])
      .fontWeight(FontWeight.Bold)
  }

  @Builder
  tailing() {
    SymbolGlyph($r('sys.symbol.more'))
      .fontSize(24)
      .fontColor([Color.White])
      .fontWeight(FontWeight.Bold)
  }
}