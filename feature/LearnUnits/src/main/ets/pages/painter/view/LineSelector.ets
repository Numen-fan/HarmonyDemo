@Component
export struct LineSelector {
  @Prop activeIndex: number = 0
  @Prop color: string = '#000000'
  private strokeWidths: number[] = []
  private onSelected?: (index: number) => void

  @Builder
  lineItem(item: number, index: number) {
    Row() {
      Shape().height(item).width(64).backgroundColor(this.color)
    }.height(20)
    .width(80)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .border(index === this.activeIndex ? { width: 1.5, radius: 10, color: '#317bd4' } : { color: Color.Transparent })
    .onClick(() => this.onSelected!(index))
  }

  build() {
    Column() {
      ForEach(this.strokeWidths, (item: number, index: number) => this.lineItem(item, index))
    }
  }
}