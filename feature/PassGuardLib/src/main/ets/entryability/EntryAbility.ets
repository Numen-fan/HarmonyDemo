import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import {
  OHGmSslSetProxyLog,
  OHGmSslSetSslLicense,
  OHGmSslSetCACert,
  OHGmSslSetRootCert,
  OHGmSslSetCACertVerifyExpand,
  OHGmSslSetTargetIPPort,
  OHGmSslStartProxy
} from 'passguardlibrary';
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    OHGmSslSetProxyLog(1); //日志开关
    //设置license
    OHGmSslSetSslLicense("Z0JmUjNsc0hRUEVROEhrNlBRVE1jTjJKeWFqQWZVUE5tY1R3TEhQRGJhbWZHMlNLeFNaOUNPL3VmdCt3eHlnM2lVanptdU5xUC8wVFNHcElVQUluY1N3b2wvcEFrYXRCSGcxbG9QT2xiSFgycUpjYW03VVhLeEdsRXVxVlZtQ3ZKYTZ0ZE1WVVV0RHZlaU1GWUtod2pSQzQ0bEVtK2RZSHkyL3lvc2twTldNPXsiaWQiOjMsInR5cGUiOiJ0ZXN0IiwicGxhdGZvcm0iOjMsIm5vdGJlZm9yZSI6IjIwMjQwMjIxIiwibm90YWZ0ZXIiOiIyMDI0MDUyMSJ9");
    //设置TargetIPPort
    OHGmSslSetTargetIPPort("ebssec.boc.cn:443");
    //启动本地转发服务
    OHGmSslStartProxy(this.context, 8899); //启动国密服务
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
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
