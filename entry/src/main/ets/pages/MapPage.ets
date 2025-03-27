import {
  AMap,
  BitmapDescriptorFactory,
  CameraUpdateFactory,
  LatLng,
  MapsInitializer,
  MapView,
  MapViewComponent,
  MapViewManager,
  MarkerOptions,
  MyLocationStyle,
  PolylineOptions,
} from '@amap/amap_lbs_map3d';
import { Constants } from "../Util/Constants";
import { LocationUtil } from "../Util/LocationUtil";
import { SearchComponent } from "../components/SearchComponent";
import { RequestUtil } from "../Util/RequestUtil";
import { TipsResult } from "../bean/TipsResult";
import { ArrayList, JSON } from "@kit.ArkTS";
import { TipBean } from '../bean/TipBean';
import { SearchList } from '../components/SearchList';
import { promptAction } from '@kit.ArkUI';
import { Step } from '../bean/RoutePlan';

const TAG = '[MapPage]'

@Entry
export struct MapPage {
  private mapView?: MapView
  private aMap?: AMap
  // 默认经纬度，天安门
  // "latitude":29.632389972857297,"longitude":106.74917376423693
  private latitude: number = 39.912393;
  private longitude: number = 116.42217;
  private adCode?: number
  @State tipBeans: Array<TipBean> = []

  aboutToAppear(): void {
    this.initMap();
    this.latitude = AppStorage.get<number>('lastLatitude') || 39.912393;
    this.longitude = AppStorage.get<number>('lastLongitude') || 116.42217;
    console.warn(TAG, `location is ${this.latitude},${this.longitude}`)
  }

  initMap() {
    MapsInitializer.setApiKey(Constants.API_KEY);
    MapViewManager.getInstance().registerMapViewCreatedCallback((mapview?: MapView, mapViewName?: string) => {
      if (!mapview) {
        return;
      }
      this.mapView = mapview;
      this.mapView.onCreate();
      this.mapView.getMapAsync((map) => {
        this.aMap = map;
        let locationStyle: MyLocationStyle = new MyLocationStyle(); //定位样式构造函数
        //设置我的位置展示模式
        locationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW); //定位、且将视角移动到地图中心点，定位点跟随设备移动
        this.aMap?.setMyLocationStyle(locationStyle); //设置定位图层的样式
        this.updateMap(this.latitude, this.longitude)
        this.getLocation();
      })
    })
  }

  getLocation() {
    LocationUtil.getInstance().getLocation(getContext(), (location) => {
      this.adCode = location['adCode']
      this.updateMap(location['latitude'], location['longitude'])
    })
  }

  async updateMap(latitude: number, longitude: number) {
    this.latitude = latitude
    this.longitude = longitude
    AppStorage.setOrCreate<number>('lastLatitude', latitude)
    AppStorage.setOrCreate<number>('lastLongitude', longitude)
    try {
      this.aMap?.clear()
      // 显示蓝
      let points: ArrayList<MarkerOptions> = new ArrayList<MarkerOptions>()
      points.add(await this.getMyLocationPoint());
      this.aMap?.addMarkers(points, true);
    } catch (e) {
      console.error(TAG, JSON.stringify(e))
    }
    this.aMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(latitude, longitude), 15))
  }

  async getMyLocationPoint() {
    let options: MarkerOptions = new MarkerOptions();
    options.setPosition(new LatLng(this.latitude, this.longitude));
    let bitmapDes =
      await BitmapDescriptorFactory.fromRawfilePath(getContext().getApplicationContext(), "location_now.png");
    if (bitmapDes) {
      options.setIcon(bitmapDes);
    }
    return options;
  }

  startSearch(keywords: string) {
    if (!(keywords && keywords.length)) {
      return
    }
    RequestUtil.queryForKeyword(keywords, this.longitude, this.latitude, this.adCode).then((data: TipsResult) => {
      // 查回来的数据
      console.warn(TAG, JSON.stringify(data))
      if (data.status == 1) {
        this.tipBeans = data.tips
      } else {
        promptAction.showToast({ message: data.info ?? "搜索失败，请重试" })
      }
    })
  }

  /**
   * 定位到特定的点
   * @param location
   * @param name
   */
  async locationToPoint(location: string | undefined, name: string | undefined) {
    if (location && location.indexOf(',') > 0) {
      let loc: string[] = location.split(',')
      let pointBitmap =
        await BitmapDescriptorFactory.fromRawfilePath(getContext().getApplicationContext(), "marker_icon.png");
      let options: MarkerOptions = new MarkerOptions();
      options.setPosition(new LatLng(Number(loc[1]), Number(loc[0])));
      options.setIcon(pointBitmap)
      if (name) {
        options.setTitle(`${name}(${LocationUtil.fmtLocation(Number(loc[1]))},${LocationUtil.fmtLocation(Number(loc[0]))})`)
      }
      this.aMap?.clear()
      let marker = this.aMap?.addMarker(options)
      this.aMap?.addMarker(await this.getMyLocationPoint())
      if (marker) {
        marker.showInfoWindow()
      }
      this.aMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(Number(loc[1]), Number(loc[0])), 15))
    }
  }

  async showOnMap() {
    // 在地图上展示点
    // 转为地图点
    let points: ArrayList<MarkerOptions> = new ArrayList<MarkerOptions>()
    try {
      for (let index = 0; index < this.tipBeans.length; index++) {
        let location = this.tipBeans[index].location;
        if (location && location.indexOf(',') > 0) {
          let loc: string[] = location.split(',')
          let pointBitmap =
            await BitmapDescriptorFactory.fromRawfilePath(getContext().getApplicationContext(), "marker_icon.png");
          let options: MarkerOptions = new MarkerOptions();
          options.setPosition(new LatLng(Number(loc[1]), Number(loc[0])));
          options.setIcon(pointBitmap)
          points.add(options)
        }
      }

      this.aMap?.clear()
      points.add(await this.getMyLocationPoint())
      this.aMap?.addMarkers(points, true);
    } catch (e) {
      console.error(TAG, JSON.stringify(e))
    }
    // 2、清空搜索结果面板
    this.tipBeans = [];
  }

  funcClick(func: number) {
    if (func === 1) {
      this.aMap?.moveCamera(CameraUpdateFactory.zoomIn())
    } else if (func === 2) {
      this.aMap?.moveCamera(CameraUpdateFactory.zoomOut())
    } else if (func === 3) {
      this.aMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(this.latitude, this.longitude), 15))
    } else if (func === 4) {
      // 进入到路线搜索
      RequestUtil.queryRoute(`${this.longitude},${this.latitude}`, "106.800299,29.656026",Constants.PLAN_BICYCLING).then(resp => {
        console.warn(TAG, JSON.stringify(resp))
        if (resp.status !== '1') {
          return;
        }
        if (resp.route && resp.route.paths && resp.route.paths[0] && resp.route.paths[0].steps) {
          let steps: Step[] = (resp.route.paths[0].steps) as Step[]
          let polylineOptionsList: ArrayList<LatLng> = new ArrayList<LatLng>()
          for (let index = 0; index < steps.length; index++) {
            const item = steps[index];
            if (!item.polyline) {
              continue;
            }
            let points = item.polyline.split(";");
            for (let i = 0; i < points.length; i++) {
              const point = points[i].split(",");
              polylineOptionsList.add(new LatLng(Number(point[1]), Number(point[0])))
            }
          }
          if (polylineOptionsList.length) {
            let options: PolylineOptions = new PolylineOptions();
            options.addAll(polylineOptionsList)
            this.aMap?.addPolyline(options);
          }
        }
      })
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      MapViewComponent()
        .width('100%')
        .height('100%')
      SearchComponent({
        onSubmit: (value) => {
          this.startSearch(value)
        },
        onChange: () => {
          this.tipBeans = []
        },
        content: () => {
          this.searchContent()
        }
      })

      this.funcAreaComponent()

    }
  }

  @Builder
  searchContent() {
    SearchList({
      tipBeans: this.tipBeans, showOnMap: () => {
        this.showOnMap()
      }, onItemClick: (item: TipBean) => {
        this.tipBeans = []
        this.locationToPoint(item.location, item.name);
      }
    })
  }

  /**
   * 功能区组件
   */
  private iconSize = 30

  @Builder
  funcAreaComponent() {
    Column({ space: 10 }) {
      // 放大
      Image($r('app.media.icon_larger'))
        .width(this.iconSize)
        .height(this.iconSize)
        .onClick(() => {
          this.funcClick(1)
        })
      // 缩小
      Image($r('app.media.icon_smaller'))
        .width(this.iconSize)
        .height(this.iconSize)
        .onClick(() => {
          this.funcClick(2)
        })
      // 定位
      Image($r('app.media.icon_location'))
        .width(this.iconSize)
        .height(this.iconSize)
        .onClick(() => {
          this.funcClick(3)
        })
      // 路线搜索
      Image($r('app.media.icon_guide'))
        .width(this.iconSize)
        .height(this.iconSize)
        .onClick(() => {
          this.funcClick(4)
        })
    }
    .width(50)
    .padding(10)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .position({
      right: 0, // 贴紧右侧
      bottom: 80 // 距离底部 100vp
    })
    .margin(10); // 可选：避免内容紧贴边缘
  }
}