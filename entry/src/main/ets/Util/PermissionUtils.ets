import { abilityAccessCtrl, bundleManager, common, PermissionRequestResult, Permissions, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
const TAG = 'PermissionUtil'
// 校验应用是否被授予权限
async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(TAG, `checkAccessToken: Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = atManager.checkAccessTokenSync(tokenId, permission);
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(TAG,`checkAccessToken: Failed to check access token. Code is ${err.code}, message is ${err.message}`);
  }

  return grantStatus;
}

async function reqPermissionsFromUser(context: Context, permissions: Array<Permissions>): Promise<number[]> {
  let atManager = abilityAccessCtrl.createAtManager();
  let grantStatus: PermissionRequestResult | null
  try {
    grantStatus = await atManager.requestPermissionsFromUser(context, permissions);
    return grantStatus.authResults;
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(TAG,`reqPermissionsFromUser: Failed to request permission. Code is ${err.code}, message is ${err.message}`);
  }
  return Array.from({
    length: permissions.length
  }, (v: Number, k: number): number => {
    return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
  });
}

async function checkPermission(permission: Permissions): Promise<boolean> {
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permission);

  return grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
}

async function checkPermissions(permissions: Array<Permissions>): Promise<boolean[]> {
  let result: boolean[] = []
  for (let i = 0; i < permissions.length; i++) {
    let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions[i]);
    result.push(grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
  }
  return result
}

async function openPermissionsInSystemSettings() {
  let context = getContext() as common.UIAbilityContext;
  const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)
  let wantInfo: Want = {
    bundleName: 'com.huawei.hmos.settings',
    abilityName: 'com.huawei.hmos.settings.MainAbility',
    uri: 'application_info_entry',
    parameters: {
      pushParams: bundleInfo.name // 打开指定应用的详情页面
    }
  }
  context.startAbility(wantInfo).catch((err: BusinessError) => {
    console.error(TAG,`openPermissionsInSystemSettings: Failed to open system setting. Code is ${err.code}, message is ${err.message}`);
  })
}

export {
  checkPermissions, checkPermission, reqPermissionsFromUser, openPermissionsInSystemSettings
}