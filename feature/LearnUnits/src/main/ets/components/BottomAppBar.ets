import { MenuMeta } from "../model/MenuMeta"

@Component
export struct BottomAppBar {
  @Prop data: MenuMeta[] = []
  @Prop activeIndex: number = 0
  private onSelected?: (index: number) => void

  build() {
    Column() {
      Divider()
        .margin({bottom:8})
      Flex({ alignItems: ItemAlign.Center }) {
        ForEach(this.data, (item: MenuMeta, index: number) => {
          TabItem({ item: item, selected: this.activeIndex == index, onTap: () => this.onSelected!(index) })
        })
      }
    }
  }
}

@Component
struct TabItem {
  @Prop item: MenuMeta
  @Prop selected: boolean = false
  private onTap = () => {
  }

  build() {
    Column() {
      Image(this.item.icon)
        .fillColor(this.selected ? $r('app.color.theme_color') : Color.Grey)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })
      Text(this.item.title)
        .fontSize(12)
        .fontColor(this.selected ? $r('app.color.theme_color') : Color.Gray)
    }.onClick(() => {
      this.onTap()
    }).layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}