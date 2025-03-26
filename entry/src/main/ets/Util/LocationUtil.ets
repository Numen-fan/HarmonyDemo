import { Constants } from "./Constants";
import { AMapPrivacyAgreeStatus, AMapPrivacyInfoStatus, AMapPrivacyShowStatus } from '@amap/amap_lbs_common';
import {
  AMapLocationManagerImpl,
  AMapLocationOption,
  AMapLocationReGeocodeLanguage,
  AMapLocationType,
  IAMapLocationListener
} from "@amap/amap_lbs_location";
import { checkPermissions, reqPermissionsFromUser } from "./PermissionUtils";
import { abilityAccessCtrl, Permissions } from "@kit.AbilityKit";
import { promptAction } from "@kit.ArkUI";
import { geoLocationManager } from "@kit.LocationKit";

const TAG = "[LocationUtil]"

type LocationCallback = (location: object) => void

export class LocationUtil {
  private static instance: LocationUtil;
  private locationManger?: AMapLocationManagerImpl;

  // 私有构造函数，防止外部实例化
  private constructor() {

  }

  // 获取单例实例的方法
  public static getInstance(): LocationUtil {
    if (!LocationUtil.instance) {
      LocationUtil.instance = new LocationUtil();
    }
    return LocationUtil.instance;
  }

  public async init() {
    //设置Key
    AMapLocationManagerImpl.setApiKey(Constants.API_KEY);
    //初始化隐私政策
    AMapLocationManagerImpl.updatePrivacyShow(AMapPrivacyShowStatus.DidShow, AMapPrivacyInfoStatus.DidContain,
      getContext(this))
    AMapLocationManagerImpl.updatePrivacyAgree(AMapPrivacyAgreeStatus.DidAgree, getContext(this))
    //创建AMapLocationManagerImpl
    this.locationManger = new AMapLocationManagerImpl(getContext(this));
    if (this.locationManger === undefined) {
      this.locationManger = new AMapLocationManagerImpl(getContext(this));
    }
  }

  public getLocation(context: Context, callback: LocationCallback) {
    // 判断是否具有位置权限
    let permissions: Permissions[] = ["ohos.permission.APPROXIMATELY_LOCATION", "ohos.permission.LOCATION"]
    checkPermissions(permissions).then((res) => {
      if (!res.some(i => i == false)) {
        // 1 如果具有位置权限，直接调用位置获取接口
        this.fetchLocation(callback)
      } else {
        // 2 如果不具备位置权限，先弹窗说明原因，随后申请位置权限
        reqPermissionsFromUser(context, permissions).then(res => {
          if (res.some(i => i != abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)) {
            // 用户拒绝，toast提示
            promptAction.showToast({
              message: "拒绝定位权限，暂时无法提供精确位置服务",
              duration: 2000
            })
          } else {
            // 进行位置获取
            this.fetchLocation(callback)
          }
        })
      }
    })
  }

  public fetchLocation(callback: LocationCallback) {
    // 定位参数配置
    let options: AMapLocationOption = {
      priority: geoLocationManager.LocationRequestPriority.ACCURACY, //定位优先配置选项
      scenario: geoLocationManager.LocationRequestScenario.UNSET, //定位场景设置
      maxAccuracy: 150, //定位精度 单位：米
      allowsBackgroundLocationUpdates: false, // 是否允许后台定位
      singleLocationTimeout: 3000, //指定单次定位超时时间
      // locatingWithReGeocode: true, //定位是否返回逆地理信息
      // reGeocodeLanguage: AMapLocationReGeocodeLanguage.Chinese, //逆地址语言类型
      isOffset: true //是否加偏
    }
    // 定位信息监听
    let locationListener: IAMapLocationListener = {
      onLocationChanged: (location) => {
        console.warn(TAG, JSON.stringify(location))
        let locationBean = new Object({
          locationFlag: 'Y',
          locationCityCode: location.reGeo?.citycode,
          lastCityCode: '',
          longitude: location.longitude,
          latitude: location.latitude,
          lastCityName: '',
          currentCity: location.reGeo?.city,
          cityCode: location.reGeo?.citycode,
          locationProvince: location.reGeo?.province,
          locationCountry: location.reGeo?.country,
          adCode:location.reGeo?.adcode
        })
        // const adCode =  location.reGeo?.adcode
        // if (adCode && adCode.length > 2) {
        //   locationBean['provinceCode'] = adCode.substring(0, 2)
        // }
        callback(locationBean)
      }, onLocationError: (error) => {
        console.error(TAG, 'error  ' + JSON.stringify(error))
      }
    };

    this.locationManger?.setLocationListener(AMapLocationType.Single, locationListener) //设置定位信息监听
    this.locationManger?.setLocationOption(AMapLocationType.Single, options) //设置定位配置项
    this.locationManger?.requestSingleLocation() //单次定位

  }

  public static fmtLocation(location: number | '' | undefined): string {
    if (location) {
      return location.toFixed(6)
    }
    return ''
  }
}
