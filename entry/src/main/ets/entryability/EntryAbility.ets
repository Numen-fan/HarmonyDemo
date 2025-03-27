import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { LocationUtil } from '../Util/LocationUtil';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    LocationUtil.getInstance().init()

    windowStage.getMainWindow().then((win) => {
      let windClass: window.Window = win
      // 设置窗口隐私模式
      try {
        windClass.setWindowPrivacyMode(true)
      } catch (exception) {
        console.error('Failed to set the window to privacy mode. Cause:' + JSON.stringify(exception))
      }

      // 1. 设置窗口全屏
      let isLayoutFullScreen = true;
      windClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      }).catch((error: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(error));
      })

      // 2 获取布局避让遮挡的区域
      let avoidArea = windClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) // 导航栏
      let bottomRectHeight = avoidArea.bottomRect.height; // 单位是像素px
      AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight)
      avoidArea = windClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM) // 状态栏
      let topRectHeight = avoidArea.topRect.height
      AppStorage.setOrCreate("topRectHeight", topRectHeight)

      windClass.on("avoidAreaChange", (data) => {
        if (data && data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          let topRectHeight = data.area.topRect.height
          AppStorage.setOrCreate("topRectHeight", topRectHeight)
        } else if (data && data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          let bottomRectHeight = data.area.bottomRect.height
          AppStorage.setOrCreate("bottomRectHeight", bottomRectHeight)
        }
      })

    })

    windowStage.loadContent('pages/MapPage', (err) => {
      // 初始化上一次的位置
      PersistentStorage.persistProp<number>('lastLatitude', 39.909187);
      PersistentStorage.persistProp<number>('lastLongitude', 116.397455);
      PersistentStorage.persistProp<number>('randomNum', 1000);

      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
