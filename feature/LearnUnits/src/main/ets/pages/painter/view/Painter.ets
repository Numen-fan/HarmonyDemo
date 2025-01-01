import { AppBar } from '../../../components/AppBar'
import { PainterBloc } from '../bloc/PainterBloc'
import { ColorSelector } from './ColorSelector';
import { LineSelector } from './LineSelector';

@Component
export struct Painter {
  @State model: PainterBloc = new PainterBloc();

  @Builder
  title() {
    Text('画板绘制').fontSize('18fp').fontWeight(FontWeight.Bold).margin({ left: 12 })
  }

  @Builder
  backButton() {
    Button() {
      SymbolGlyph($r('sys.symbol.trash')).fontSize(26)
    }.width(36).height(36).backgroundColor(Color.Transparent)
    .onClick(() => {
      this.showClearDialog()
    })
  }

  @Builder
  actionsButton() {
    Row() {
      Button() {
        SymbolGlyph($r('sys.symbol.undo')).fontSize(24)
      }.size({ width: 36, height: 36 }).backgroundColor(Color.Transparent)
      .enabled(this.model.lineCount > 0)
      .onClick(() => this.model.back())

      Button() {
        SymbolGlyph($r('sys.symbol.redo')).fontSize(24)
      }.size({ width: 36, height: 36 }).backgroundColor(Color.Transparent)
      .enabled(this.model.historyLineCount > 0)
      .onClick(() => {
        this.model.revocation()
      })
    }
  }

  @Builder
  appBar() {
    AppBar({
      titleSolt: this.title,
      tailing: () => {
        // 尾部
        this.backButton()
      },
      leading: () => {
        this.actionsButton()
      },
      bgColor: Color.White
    })
  }

  @Builder
  canvas() {
    Canvas(this.model.context)
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#fafafa')
      .gesture(
        PanGesture()
          .onActionStart((e) => this.onPanStart(e))
          .onActionUpdate((e) => this.onPanUpdate(e))
      )
  }

  @Builder
  selector() {
    Row() {
      ColorSelector({
        colors: this.model.supportColors,
        activeIndex: this.model.colorIndex,
        onSelected: (index) => {
          this.model.changeColor(index)
        }
      }).layoutWeight(1)
      LineSelector({
        strokeWidths: this.model.supportStrokeWidths,
        activeIndex: this.model.strokeWidthIndex,
        color: this.model.currentColor(),
        onSelected: (index) => {
          this.model.changeStrokeWidth(index)
        }
      }).margin({ left: 8 })
    }.padding({ left: 12, right: 12 }).position({ bottom: 24 })

  }

  onPanStart(e: GestureEvent): void {
    if (e.fingerList.length < 0) {
      return
    }
    let x = e.fingerList[0].localX
    let y = e.fingerList[0].localY
    this.model.newLine(x, y)
  }

  onPanUpdate(e: GestureEvent): void {
    if (e.fingerList.length < 0) {
      return;
    }
    let x = e.fingerList[0].localX;
    let y = e.fingerList[0].localY;
    this.model.updateLine(x, y);
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          this.appBar()
          this.canvas()
        }
        .width('100%')
        .height('100%')

        this.selector()
      }
    }.hideTitleBar(true)

  }

  showClearDialog() {
    AlertDialog.show({
      title: "清空操作提示",
      message: "您的当前操作会清空所有的绘制内容，是否确定继续！",
      autoCancel: true,
      cornerRadius: 8,
      alignment: DialogAlignment.Center,
      gridCount: 4,
      primaryButton: {
        value: '取消', action: () => {
        }
      },
      secondaryButton: {
        enabled: true,
        defaultFocus: true,
        style: DialogButtonStyle.HIGHLIGHT,
        backgroundColor: '#fe5455',
        value: '确定',
        action: () => this.model.clear()
      }
    })
  }
}

@Builder
export function pageBuilder() {
  Painter()
}