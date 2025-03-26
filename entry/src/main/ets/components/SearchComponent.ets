const TAG = '[SearchComponent]'

@Component
export struct SearchComponent {
  @StorageProp('topRectHeight')
  topRectHeight: number = 0
  @State searchText?: string = undefined
  controller?: SearchController = new SearchController()
  onSubmit: (value: string) => void = (value) => {

  }
  onChange: () => void = () => {
  }

  @Builder
  contentBuilder() {
  }

  @BuilderParam content: () => void = this.contentBuilder

  build() {
    Row() {
      Column() {
        Search({
          placeholder: "输入搜索内容",
          value: this.searchText,
          controller: this.controller
        })
          .type(SearchType.NORMAL)
          .enterKeyType(EnterKeyType.Search)
          .height(40)
          .backgroundColor(Color.White)
          .onSubmit((value) => {
            console.log(TAG, "onSubmit", value)
            this.onSubmit(value)
          })
          .onChange((value) => {
            console.log(TAG, "onChange", value)
            this.onChange()
          })
        // 搜索结果
        this.content()
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
    } // Column
    .width('100%')
    .padding({left:10, right:10, top:px2vp(this.topRectHeight)})

  }
}