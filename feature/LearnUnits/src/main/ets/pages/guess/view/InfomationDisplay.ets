import { CheckResult } from "../model/CheckResult";

@Component
export struct InfomationDisplay {
  @Prop result: CheckResult = CheckResult.none;
  @Prop guessing: boolean = false;
  @Prop secret: number = 0;

  constructor() {
    super();
    console.warn("InfomationDisplay")
  }

  info(): string {
    if (this.result === CheckResult.equal) {
      return '恭喜你猜对啦~'
    } else if (!this.guessing) {
      return '点击生成随机数'
    }
    return '开始输入你猜的数字吧'
  }

  value(): string {
    if (this.guessing) {
      return '**'
    }
    return this.secret.toString()
  }

  build() {
    Column() {
      Text(this.info())
      Text(this.value()).fontSize(46).fontColor('#7272772')
    }.width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Transparent)
  }
}