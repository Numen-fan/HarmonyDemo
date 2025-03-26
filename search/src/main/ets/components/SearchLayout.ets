import { HistoryItemAttribute } from '../attribute/HistoryItemAttribute'
import { HistoryTagAttribute } from '../attribute/HistoryTagAttribute'
import { HotTagAttribute } from '../attribute/HotTagAttribute'
import { SearchViewAttribute } from '../attribute/SearchViewAttribute'
import { HotBean } from '../model/HotBean'
import { PreferencesUtil } from '../utils/PreferencesUtil'
import { HotItemAttribute } from '../attribute/HotItemAttribute'
import { SearchResultController } from '../controller/SearchResultController'

/**
 * AUTHOR:AbnerMing
 * DATE:2025/03/04
 * INTRODUCE:自定义搜索视图
 * */
@Component
export struct SearchLayout {
  @State historyList: string[] = []
  @Prop hotList: HotBean[] = []
  onHistoryItemAttribute?: (attribute: HistoryItemAttribute) => void //历史条目属性
  private historyItemAttribute: HistoryItemAttribute = new HistoryItemAttribute()
  onHotItemAttribute?: (attribute: HotItemAttribute) => void //热门条目属性
  private hotItemAttribute: HotItemAttribute = new HotItemAttribute()
  historyViewMarginTop?: Length = 20
  historyViewMarginBottom?: Length
  hotViewMarginTop?: Length = 20
  rootMargin?: Padding | Length | LocalizedPadding = { left: 10, right: 10 } //总体的边距
  onHistoryTagAttribute?: (attribute: HistoryTagAttribute) => void //历史标签属性
  private historyTagAttribute: HistoryTagAttribute = new HistoryTagAttribute()
  onHotTagAttribute?: (attribute: HotTagAttribute) => void //热门标签属性
  private hotTagAttribute: HotTagAttribute = new HotTagAttribute()
  onSearchAttribute?: (attribute: SearchViewAttribute) => void //搜索属性
  private searchAttribute: SearchViewAttribute = new SearchViewAttribute()
  controller?: SearchController = new SearchController()
  @BuilderParam searchLeftView: () => void
  @BuilderParam searchRightView: () => void
  onItemClick?: (text: string) => void
  @State searchText?: string = undefined
  @State @Watch("searchResultListener") searchResultController: SearchResultController = new SearchResultController()
  private searchResult?: string = undefined

  searchResultListener() {
    if (this.searchResultController.isSubmit && this.searchResult != undefined) {
      //点击了搜索
      this.submit(this.searchResult)
      this.searchResultController.isSubmit = false
    }
  }

  aboutToAppear(): void {
    if (this.onHistoryItemAttribute != undefined) {
      this.onHistoryItemAttribute(this.historyItemAttribute)
    }
    if (this.onHistoryTagAttribute != undefined) {
      this.onHistoryTagAttribute(this.historyTagAttribute)
    }
    if (this.onHotTagAttribute != undefined) {
      this.onHotTagAttribute(this.hotTagAttribute)
    }
    if (this.onSearchAttribute != undefined) {
      this.onSearchAttribute(this.searchAttribute)
    }
    if (this.onHotItemAttribute != undefined) {
      this.onHotItemAttribute(this.hotItemAttribute)
    }

    this.searchText = this.searchAttribute.value

    PreferencesUtil.getPreferencesUtil().init(getContext())

    let searchList = PreferencesUtil.getPreferencesUtil().get("searchList")
    if (searchList != undefined && searchList != "") {
      searchList.split(",").forEach((item) => {
        this.historyList.push(item)
      })
    }

  }

  aboutToDisappear(): void {
    PreferencesUtil.getPreferencesUtil().put("searchList", this.historyList.toString())
  }

  build() {
    Column() {

      RelativeContainer() {

        Column() {
          if (this.searchLeftView != undefined) {
            this.searchLeftView()
          }
        }.id("search_left")
        .height("100%")
        .justifyContent(FlexAlign.Center)

        Search({
          placeholder: this.searchAttribute.placeholder,
          value: this.searchText,
          icon: this.searchAttribute.icon,
          controller: this.controller
        })
          .placeholderFont(this.searchAttribute.placeholderFont)
          .placeholderColor(this.searchAttribute.placeholderColor)
          .textFont(this.searchAttribute.textFont)
          .textAlign(this.searchAttribute.textAlign)
          .copyOption(this.searchAttribute.copyOption)
          .searchIcon(this.searchAttribute.searchIcon)
          .cancelButton(this.searchAttribute.cancelButton)
          .fontColor(this.searchAttribute.fontColor)
          .caretStyle(this.searchAttribute.caretStyle)
          .enableKeyboardOnFocus(this.searchAttribute.enableKeyboardOnFocus)
          .selectionMenuHidden(this.searchAttribute.selectionMenuHidden)
          .maxLength(this.searchAttribute.maxLength)
          .enterKeyType(this.searchAttribute.enterKeyType)
          .type(this.searchAttribute.type)
          .alignRules({
            left: { anchor: "search_left", align: HorizontalAlign.End },
            right: { anchor: "search_right", align: HorizontalAlign.Start },
            center: { anchor: "__container__", align: VerticalAlign.Center }
          })
          .onSubmit((text: string) => {

            this.submit(text)
          })
          .onChange((value) => {
            this.searchResult = value
          })

        Column() {
          if (this.searchRightView != undefined) {
            this.searchRightView()
          }
        }.id("search_right")
        .height("100%")
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          right: { anchor: "__container__", align: HorizontalAlign.End }
        }).justifyContent(FlexAlign.Center)

      }.width("100%")
      .height(this.searchAttribute.height)
      .margin(this.searchAttribute.margin)

      RelativeContainer() {

        Text(this.historyTagAttribute.title)
          .fontColor(this.historyTagAttribute.fontColor)
          .fontSize(this.historyTagAttribute.fontSize)
          .fontWeight(this.historyTagAttribute.fontWeight)

        Image(this.historyTagAttribute.deleteSrc)
          .width(this.historyTagAttribute.imageWidth)
          .width(this.historyTagAttribute.imageHeight)
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          }).onClick(() => {
          //删除
          this.historyList = []
          PreferencesUtil.getPreferencesUtil().delete("searchList")
        })

      }.margin(this.historyTagAttribute.margin)
      .height(this.historyTagAttribute.height)
      .visibility(this.historyList.length == 0 ? Visibility.None : Visibility.Visible)

      Flex({
        direction: FlexDirection.Row, wrap: FlexWrap.Wrap,
        space: { main: this.historyItemAttribute.main, cross: this.historyItemAttribute.cross }
      }) {
        ForEach(this.historyList, (item: string) => {
          Text(item)
            .padding(this.historyItemAttribute.padding)
            .borderRadius(this.historyItemAttribute.borderRadius)
            .fontColor(this.historyItemAttribute.fontColor)
            .fontSize(this.historyItemAttribute.fontSize)
            .fontWeight(this.historyItemAttribute.fontWeight)
            .backgroundColor(this.historyItemAttribute.backgroundColor)
            .onClick(() => {
              //历史搜索点击
              if (this.onItemClick != undefined) {
                this.onItemClick(item)
              }
            })

        })
      }
      .margin({ top: this.historyViewMarginTop, bottom: this.historyViewMarginBottom })
      .visibility(this.historyList.length == 0 ? Visibility.None : Visibility.Visible)

      Text(this.hotTagAttribute.title)
        .fontColor(this.hotTagAttribute.fontColor)
        .fontSize(this.hotTagAttribute.fontSize)
        .fontWeight(this.hotTagAttribute.fontWeight)
        .margin(this.hotTagAttribute.margin)

      Grid() {
        ForEach(this.hotList, (item: HotBean) => {
          GridItem() {
            Row() {
              if (item.label != undefined && item.label.name != undefined) {
                //带有序号的
                Text(item.label.name)
                  .backgroundColor(item.label.bgColor)
                  .textAlign(TextAlign.Center)
                  .borderRadius(this.hotItemAttribute.labelSize)
                  .margin({ right: this.hotItemAttribute.labelMarginRight })
                  .fontSize(this.hotItemAttribute.labelFontSize)
                  .fontColor(this.hotItemAttribute.labelFontColor)
                  .fontWeight(this.hotItemAttribute.labelFontWeight)
                  .padding(this.hotItemAttribute.labelPadding)
              } else if (item.label != undefined && (item.label.src != undefined || item.label?.bgColor != undefined)) {
                Image(item.label?.src)
                  .backgroundColor(item.label?.bgColor)
                  .width(this.hotItemAttribute.labelSize)
                  .height(this.hotItemAttribute.labelSize)
                  .borderRadius(this.hotItemAttribute.labelSize)
                  .margin({ right: this.hotItemAttribute.labelMarginRight })
              }

              Text(item.name)
                .fontSize(this.hotItemAttribute.fontSize)
                .fontColor(this.hotItemAttribute.fontColor)
                .fontWeight(this.hotItemAttribute.fontWeight)
            }
            .width("100%")
            .backgroundColor(this.hotItemAttribute.backgroundColor)
            .justifyContent(FlexAlign.Start)
            .onClick(() => {
              //历史搜索点击
              if (this.onItemClick != undefined) {
                this.onItemClick(item.name!)
              }
            })
          }
        })
      }.columnsTemplate(this.hotItemAttribute.columnsTemplate)
      .margin({ top: this.hotViewMarginTop })
      .rowsGap(this.hotItemAttribute.rowsGap)
    }.width("100%")
    .alignItems(HorizontalAlign.Start)
    .padding(this.rootMargin)
  }

  removeFirst(arr: string[], value: string): string[] {
    const index = arr.indexOf(value)
    if (index !== -1) {
      arr.splice(index, 1)
    }
    return arr
  }

  private submit(text: string) {

    //这里进行对数据存储
    if (this.historyList.indexOf(text) != -1) {
      this.historyList = this.removeFirst(this.historyList, text)
    }
    this.historyList.unshift(text)
    if (this.searchAttribute.onSubmit != undefined) {
      this.searchAttribute.onSubmit(text)
    }
    if (this.historyList.length > 10) {
      this.historyList.pop()
    }
  }
}