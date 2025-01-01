@Component
export struct AppBar {
  private title: string | Resource = ''
  private bgColor = $r('app.color.theme_color')
  @StorageProp('topRectHeight')
  topRectHeight: number = 0

  // 以下是两个Builder函数
  @Builder
  leadingBuilder() {
  }

  @Builder
  tailingBuilder() {
  }

  @Builder
  titleBuilder() {
    Text(this.title)
      .fontSize(20).fontWeight(FontWeight.Bold)
      .fontColor($r('sys.color.white'))
  }

  // leader是参数，类型是一个函数即()=>void,默认值是this.leadingBuilder
  // @BuilderParam声明的参数不能为空，必须由@Builder来初始化
  @BuilderParam leading: () => void = this.leadingBuilder
  @BuilderParam tailing: () => void = this.tailingBuilder
  @BuilderParam titleSolt: () => void = this.titleBuilder

  build() {
    Stack() {
      Row() {
        this.leading() // 是需要调用leading函数的
        this.tailing()
      }
      .backgroundColor(this.bgColor)
      .width('100%')
      .height(56)
      .padding({ left: 8, right: 8 })
      .justifyContent(FlexAlign.SpaceBetween)

      this.titleSolt()
    }.padding({ top: px2vp(this.topRectHeight) })

  }
}