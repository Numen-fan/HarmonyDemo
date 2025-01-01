import { AppBar } from "../../../components/AppBar"
import { CheckResult } from "../model/CheckResult";
import { GuessingState } from "../model/GuessingState";
import { InfomationDisplay } from "./InfomationDisplay";
import { ResultDisplay } from "./ResultDisplay"

@Component
export struct GuessNumPage {
  @State state: GuessingState = new GuessingState()

  build() {
    Column() {
      AppBar({
        leading: this.leading,
        tailing: () => {
          this.tailing()
        },
        // titleSolt: this.titleInput,这种方式初始化titleSolt，会导致titleInput使用的this指向AppBar
        // 通过闭包，以调用的方式，此时 titleInput 中的 this 是 GuessingPage]
        titleSolt:
        () => {
          this.titleInput()
        }
      })
      Stack() {
        Column() {
          ResultDisplay({ result: this.solve(CheckResult.bigger), guessCount: this.state.guessCount })
          ResultDisplay({ result: this.solve(CheckResult.smaller), guessCount: this.state.guessCount })
        }

        InfomationDisplay({ guessing: this.state.guessing, secret: this.state.secret, result: this.state.result })
        this.button()
      }.alignContent(Alignment.BottomEnd)
      .width('100%')
      .layoutWeight(1)
    }.height('100%')
    .width('100%')
  }

  @Builder
  leading() {
    SymbolGlyph($r('sys.symbol.access_card'))
      .fontSize(24)
      .fontColor([Color.White])
      .fontWeight(FontWeight.Bold)
  }

  @Builder
  tailing() {
    SymbolGlyph($r('sys.symbol.more'))
      .fontSize(24)
      .fontColor([Color.White])
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        this.state.checkResult()
      })
  }

  @Builder
  titleInput() {
    // 注意这里text和this.input进行了双向绑定，this指向的是GuessNumPage
    TextInput({ placeholder: '输入0~99的数字', text: $$this.state.input })
      .type(InputType.Number)
      .layoutWeight(1)
      .margin({ left: 8, right: 8 })
      .backgroundColor('#F3F6F9')
      .enterKeyType(EnterKeyType.Go)
      .onSubmit(() => {
        this.state.checkResult()
      })
  }

  @Builder
  button() {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      SymbolGlyph($r('sys.symbol.location_up'))
        .fontSize(24).fontColor([Color.White]).fontWeight(FontWeight.Bold)
    }
    .onClick(() => {
      this.state.start()
    })
    .backgroundColor(this.state.guessing ? '9e9e9c' : $r('app.color.theme_color'))
    .width(56)
    .height(56)
    .margin({ right: 20, bottom: 16 })
    .enabled(!this.state.guessing)
  }



  solve(result: CheckResult): CheckResult {
    if (this.state.result == result) {
      return result;
    }
    return CheckResult.none;
  }
}