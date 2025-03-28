const TAG = '[SearchComponent]'

@Component
export struct SearchComponent {
  @StorageProp('topRectHeight')
  topRectHeight: number = 0
  @Link searchText: string
  controller?: SearchController = new SearchController()
  onSubmit: (value: string) => void = (value) => {

  }
  onChange: () => void = () => {
  }

  onFocusChange:(focus:boolean) => void = (focus: boolean) => {
  }

  @Builder
  contentBuilder() {
  }

  @Builder
  preferSearchBuilder() {

  }

  @BuilderParam content: () => void = this.contentBuilder
  @BuilderParam preferSearchContent: () => void = this.preferSearchBuilder

  build() {
    Row() {
      Column() {
        Search({
          placeholder: "输入搜索内容",
          value: this.searchText,
          controller: this.controller,
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
            this.searchText = value
            console.log(TAG, "onChange", value)
            this.onChange()
          })
          .onFocus(()=> {
            // 聚焦
            this.onFocusChange(true)
          })
          .onBlur(()=> {
            // 失去焦点
            this.onFocusChange(false)
          })

        // 常用搜索
        this.preferSearchContent()

        // 搜索结果
        this.content()
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
    } // Column
    .width('100%')
    .padding({ left: 10, right: 10, top: px2vp(this.topRectHeight) })

  }
}