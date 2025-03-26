import { TipBean } from "../bean/TipBean"

@Component
export struct SearchList {
  @Prop
  tipBeans: Array<TipBean>
  showOnMap: () => void = () => {
  }
  onItemClick: (item: TipBean) => void = (item: TipBean) => {
  }

  @Builder
  tipItem(name?: string, address?: string) {
    Column({ space: 4 }) {
      Text(name)
        .fontSize(16)
        .margin({ left: 10 })
      Text("地址:" + address)
        .fontSize(14)
        .margin({ left: 10 })
      Line()
        .backgroundColor(Color.Gray)
        .width('100%')
        .margin({top: 3})
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Scroll() {
      Column() {
        List({ space: 10 }) {
          ForEach(this.tipBeans, (item: TipBean) => {
            ListItem() {
              if (item.name && item.location && item.location.indexOf(',') > 0) {
                this.tipItem(item.name, item.address)
              }
            }.onClick(()=> {
              this.onItemClick(item)
            })
          })
        }

        Button("地图上查看", { type: ButtonType.Normal, stateEffect: true })
          .onClick(() => {
            this.showOnMap()
          }).width('80%')
          .borderRadius(20)
          .margin({top:10})
        Blank()
          .height(10)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(10)
      .alignItems(HorizontalAlign.Center)
      .visibility(this.tipBeans && this.tipBeans.length > 0 ? Visibility.Visible : Visibility.Hidden)
      .padding({top: 10})
    }
  }
}