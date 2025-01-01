@Component
export struct AnimaValueView {
  @Prop @Watch('startAnimation') counter: number
  @State rate: number = 0
  @State addNumber: number = 0
  private lastCounter: number = 0

  build() {
    Text('功德 + ' + this.addNumber)
      .fontSize(8 + this.rate * 8)
      .translate({ y: -60 - this.rate * 64 })
      .opacity(this.rate * 0.7)
  }

  startAnimation(changedPropertyName: string) {
    this.addNumber = this.counter - this.lastCounter
    this.lastCounter = this.counter
    this.rate = 0
    let param: AnimateParam = {
      curve: Curve.LinearOutSlowIn, duration: 400, onFinish: () => this.reset()
    };
    this.getUIContext()?.animateTo(param, () => this.onEvent())
  }

  reset(): void {
    this.rate = 0
  }

  onEvent(): void {
    this.rate = 1
  }
}