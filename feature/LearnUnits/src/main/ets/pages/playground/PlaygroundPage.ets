import { CircleScaleAnimation } from "./animaton/CircleScaleAnimation"

@Component
export struct PlaygroundPage {
  build() {
    Column() {
      CircleScaleAnimation()
    }.width('100%').height('100%')
  }
}