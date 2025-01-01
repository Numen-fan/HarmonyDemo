import { CheckResult } from '../model/CheckResult';

@Component
struct ResultDisplay {
  @Prop result: CheckResult = CheckResult.none;
  @State fontSize: number = 14
  @Prop @Watch('onGuessCountChange') guessCount: number = 0

  build() {
    Column() {
      Text(this.resultLabel(this.result))
        .fontSize(this.fontSize)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
    }.layoutWeight(1)
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.resultColor(this.result))
  }

  resultLabel(result: CheckResult): string | Resource {
    switch (result) {
      case CheckResult.bigger:
        return "大了"
      case CheckResult.smaller:
        return "小了"
    }
    return ''
  }

  resultColor(result: CheckResult): ResourceColor {
    switch (result) {
      case CheckResult.bigger:
        return "#ff5454"
      case CheckResult.smaller:
        return "#448afc"
    }
    return ''
  }

  startAnimation() {
    let param: AnimateParam = { curve: Curve.EaseIn, duration: 500 };
    this.getUIContext()?.animateTo(param, () => this.onEvent());
  }

  onEvent() {
    this.fontSize = 46
  }

  onGuessCountChange(changedPropertyName: string) {
    console.warn('changedPropertyName == ' + changedPropertyName)
    this.fontSize = 16
    this.startAnimation()
  }
}

export {ResultDisplay }