import { router } from '@kit.ArkUI';

@Entry
@Component
struct SplashPage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    setTimeout(()=> {
      router.replaceUrl({url:'pages/Index'})
    }, 2000)
  }


  build() {
    RelativeContainer() {
      Image($r('app.media.launcher'))
        .width('100%')
        .height('100%')
    }
    .height('100%')
    .width('100%')
  }
}