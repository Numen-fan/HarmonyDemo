import { TipBean } from "../bean/TipBean"
import { AppBar } from "../components/AppBar"
import { SearchList } from "../components/SearchList"
import { RequestUtil } from "../Util/RequestUtil"
import { promptAction } from "@kit.ArkUI"

const TAG = "[RouteSearchPage]"

@Component
@Preview
export struct RouteSearchPage {
  @Consume('NavPathStack') pageStack: NavPathStack
  @State tipBeans: Array<TipBean> = []
  curLocation: string = ""
  @State startLocation: string | undefined = ""
  @State endLocation: string | undefined = ""
  @State origin: string = ''
  @State dest: string = ''
  originSearch: boolean = true

  @Builder
  title() {
    Text('路线搜索').fontSize('18fp').fontWeight(FontWeight.Bold).margin({ left: 12 })
  }

  @Builder
  backButton() {
    Button() {
      SymbolGlyph($r('sys.symbol.chevron_left')).fontSize(28)
        .fontColor([Color.Black])
    }.width(36).height(36).backgroundColor(Color.Transparent)
    .onClick(() => {
      this.pageStack.pop()
    })
  }

  @Builder
  appBar() {
    AppBar({
      titleSolt: this.title,
      leading: () => {
        this.backButton()
      },
      bgColor: Color.White
    })
  }

  build() {
    NavDestination() {
      Column() {
        this.appBar()
        TextInput({ placeholder: "我的位置", text: this.origin })
          .onChange(value => {
            this.origin = value
          })
          .onSubmit(() => {
            this.search(true)
          })
          .enterKeyType(EnterKeyType.Search)
        TextInput({ placeholder: "目的地", text: this.dest })
          .margin({ top: 10 })
          .onChange(value => {
            this.dest = value
          })
          .onSubmit(() => {
            this.search(false)
          })
          .enterKeyType(EnterKeyType.Search)
        Button("地图上查看", { type: ButtonType.Normal, stateEffect: true })
          .onClick(() => {
            this.showOnMap()
          })
          .width('80%')
          .borderRadius(20)
          .margin({ top: 10 })
          .visibility(!this.startLocation || this.startLocation?.length <= 0 || !this.endLocation ||
            this.endLocation?.length <= 0 ? Visibility.None : Visibility.Visible)
        SearchList({
          tipBeans: this.tipBeans,
          onItemClick: (item: TipBean) => {
            if (this.originSearch) {
              this.origin = item.name as string
              this.startLocation = item.location
            } else {
              this.dest = item.name as string
              this.endLocation = item.location
            }
            this.tipBeans = []
          }
        })
      }.height('100%')
      .width("100%")
    }.hideTitleBar(true)
    .onReady(ctx => {
      this.startLocation = ctx.pathInfo.param as string
      this.curLocation = this.startLocation
    })
  }

  // 地点搜索
  // @params start 是否是起点
  search(start: boolean) {
    this.originSearch = start
    if (start && this.origin.length < 1 || !start && this.dest.length < 1) {
      promptAction.showToast({ message: "请输入地点名称" })
      return
    }
    let keywords = start ? this.origin : this.dest
    let loc = this.curLocation.split(",")
    RequestUtil.queryForKeyword(keywords, Number(loc[0]), Number(loc[1])).then(data => {
      // 查回来的数据
      console.warn(TAG, JSON.stringify(data))
      if (data.status == 1) {
        this.tipBeans = data.tips
      } else {
        promptAction.showToast({ message: data.info ?? "搜索失败，请重试" })
      }
    })
  }

  showOnMap() {
    if (!this.startLocation || this.startLocation?.length <= 0 || !this.endLocation || this.endLocation?.length <= 0) {
      promptAction.showToast({ message: "请输入起止点" })
      return
    }
    this.pageStack.pop(Object({
      start: this.startLocation,
      end: this.endLocation
    }), false)
  }
}

@Builder
export function pageBuilder() {
  RouteSearchPage()
}