import { BottomAppBar } from "../components/BottomAppBar"
import { kTabs } from "../model/Constance"
import { CounterPage } from "./CounterPage"
import { GuessNumPage } from "./guess/view/GuessNumPage"
import { MuyuPage } from "./muyu/view/MuyuPage"
import { Painter } from "./painter/view/Painter"

@Entry({ routeName: 'LearnUnitsMainPage' })
@Component
@Preview
export struct LearnUnitsMainPage {
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()
  @State currentIndex: number = 0

  @Builder
  tabView() {
    Tabs({ index: this.currentIndex }) {
      TabContent() {
        CounterPage()
      }

      TabContent() {
        GuessNumPage()
      }

      TabContent() {
        MuyuPage()
      }

      TabContent() {
        Painter()
      }
    }.layoutWeight(1)
    .barHeight(0)
    .scrollable(false)
  }

  @Builder
  bottomAppBar() {
    BottomAppBar({
      activeIndex: this.currentIndex,
      data: kTabs,
      onSelected: (index) => this.onPageChange(index)
    })
  }

  onPageChange(index: number): void {
    this.currentIndex = index
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        this.tabView()
        this.bottomAppBar()
      }
    }
    .padding({ bottom: px2vp(this.bottomRectHeight) })
    .mode(NavigationMode.Stack)
  }

  pushHome(): void {
    this.pageStack.pushPathByName('painter', null, false)
  }
}
