import { curves } from "@kit.ArkUI";

@Component
@Preview
export struct CircleScaleAnimation {
  @State scaleValue: number = 1;

  build() {
    Shape() {
      Circle({ width: 80, height: 90 }).fill('#317bd4')
    }.scale({ x: this.scaleValue, y: this.scaleValue })
    .onClick(() => {
      this.run()
    })
  }

  run(): void {
    let param:AnimateParam = {curve:curves.springMotion(), duration: 1000, playMode: PlayMode.Alternate}
    this.getUIContext()?.animateTo(param, ()=> this.onEvent())
  }

  onEvent() {
    this.scaleValue = this.scaleValue == 1 ? 0.5 : 1;
  }
}