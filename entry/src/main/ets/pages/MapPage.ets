import {
  AMap,
  BitmapDescriptor,
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

@Entry({ routeName: 'MapPage' })
@Component
export struct MapPage {
  private mapView?: MapView
  private aMap?: AMap
  // 默认经纬度，天安门
  // 116.397455,39.909187
  @StorageLink('lastLatitude') latitude: number = 39.909187;
  @StorageLink('lastLongitude') longitude: number = 116.397455;
  @StorageLink('preferSearch') preferSearch: string = ''
  @StorageLink('randomNum') randomNum: number = 0
  private adCode?: number
  @State tipBeans: Array<TipBean> = []
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()
  @State preferShow: boolean = false;
  @State searchText: string = ''

  aboutToAppear(): void {
    this.initMap();
    console.warn(TAG, `location is ${this.latitude},${this.longitude}`)
    console.warn(TAG, `randomNum is ${this.randomNum}`)
    console.warn(TAG, 'preferSearch is ' + this.preferSearch)
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
    console.warn(TAG, AppStorage.get<number>('lastLatitude') + "")
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
    this.searchText = keywords
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
    this.searchText = name as string
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
          let options: MarkerOptions = this.getPoint(Number(loc[1]), Number(loc[0]), pointBitmap as BitmapDescriptor);
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

  getPoint(latitude: number, longitude: number, pointBitmap: BitmapDescriptor): MarkerOptions {
    let options: MarkerOptions = new MarkerOptions();
    options.setPosition(new LatLng(latitude, longitude));
    options.setIcon(pointBitmap)
    return options
  }

  // 进入到路线搜索, 默认驾车
  showRouteGuide(start: string, end: string) {
    RequestUtil.queryRoute(start, end).then(async resp => {
      console.warn(TAG, JSON.stringify(resp))
      if (resp.status !== '1') {
        promptAction.showToast({ message: '路径规划失败，请稍候重试' })
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
          // 先移除所有的覆盖物
          this.aMap?.clear()
          let options: PolylineOptions = new PolylineOptions();
          options.addAll(polylineOptionsList)
          this.aMap?.addPolyline(options);
          // 添加标记点，并移动到起点
          let pointBitmap =
            await BitmapDescriptorFactory.fromRawfilePath(getContext().getApplicationContext(), "marker_icon.png");
          let options1: MarkerOptions = new MarkerOptions();
          let loc1 = start.split(",")
          options1.setPosition(new LatLng(Number(loc1[1]), Number(loc1[0])));
          options1.setIcon(pointBitmap)
          options1.setTitle("起点")
          let marker = this.aMap?.addMarker(options1)
          if (marker) {
            marker.showInfoWindow()
          }
          let options2: MarkerOptions = new MarkerOptions();
          let loc2 = end.split(",")
          options2.setPosition(new LatLng(Number(loc2[1]), Number(loc2[0])));
          options2.setIcon(pointBitmap)
          options2.setTitle("终点")
          let marker1 = this.aMap?.addMarker(options2)
          if (marker1) {
            marker1.showInfoWindow()
          }
          // 我的位置
          this.aMap?.addMarker(await this.getMyLocationPoint())
          // 移动到起点
          this.aMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(Number(loc1[1]), Number(loc1[0])), 15))
        }
      }
    })
  }

  funcClick(func: number) {
    if (func === 1) {
      this.aMap?.moveCamera(CameraUpdateFactory.zoomIn())
    } else if (func === 2) {
      this.aMap?.moveCamera(CameraUpdateFactory.zoomOut())
    } else if (func === 3) {
      this.aMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(this.latitude, this.longitude), 15))
    } else if (func === 4) {
      // 进入路线搜索页面
      this.pageStack.pushPathByName("route_search", `${this.longitude},${this.latitude}`, (data) => {
        console.warn(TAG, "pushPathByName back", JSON.stringify(data))
        let result = data.result as object
        if (result) {
          this.showRouteGuide(result['start'] as string, result['end'] as string)
        }
      })
    } else if (func === 5) {
      this.showRandomPoint()
    } else if (func === 6) {
      this.pageStack.pushPathByName("setting", null, false)
    }
  }

  async showRandomPoint() {
    console.warn(TAG, "num = " + this.randomNum)
    if (this.randomNum <= 0) {
      promptAction.showToast({ message: "至少要1个点" })
      return
    }
    // 生成围绕当前经纬度周围的点数
    const earthRadiusKm = 6371; // 地球半径（千米）
    let points: ArrayList<MarkerOptions> = new ArrayList<MarkerOptions>()
    let pointBitmap =
      await BitmapDescriptorFactory.fromRawfilePath(getContext().getApplicationContext(), "marker_icon.png");
    for (let i = 0; i < this.randomNum; i++) {
      // 生成极坐标下的随机半径和角度
      const r = Math.sqrt(Math.random()) * this.randomNum / 1000; // 使点均匀分布在圆内
      const theta = Math.random() * 2 * Math.PI;

      // 转换为地理坐标
      const deltaLat = (r / earthRadiusKm) * (180 / Math.PI);
      const deltaLng = (r / earthRadiusKm) * (180 / Math.PI) / Math.cos(this.latitude * Math.PI / 180);

      const lat = this.latitude + deltaLat * Math.sin(theta);
      const lng = this.longitude + deltaLng * Math.cos(theta);

      let options: MarkerOptions = this.getPoint(lat, lng, pointBitmap as BitmapDescriptor);
      points.add(options)
    }
    points.add(await this.getMyLocationPoint())
    this.aMap?.clear()
    this.aMap?.addMarkers(points)
  }

  build() {
    Navigation(this.pageStack) {
      Stack({ alignContent: Alignment.Top }) {
        MapViewComponent()
          .width('100%')
          .height('100%')
        SearchComponent({
          searchText: this.searchText,
          onSubmit: (value) => {
            this.startSearch(value)
          },
          onChange: () => {
            if (!this.searchText.length) {
              this.preferShow = true
              this.tipBeans = []
            }
          },
          content: () => {
            this.searchContent()
          },
          preferSearchContent: () => {
            this.preferSearchContent()
          },
          onFocusChange: (focus: boolean) => {
            if (focus) {
              this.preferShow = this.tipBeans === null || this.tipBeans.length <= 0
            } else {
              this.preferShow = false
            }

          }
        })

        this.funcAreaComponent()

      }
    }.mode(NavigationMode.Stack)
    .hideToolBar(true)
  }

  @Builder
  searchContent() {
    SearchList({
      tipBeans: this.tipBeans,
      showOnMap: () => {
        this.showOnMap()
      },
      onItemClick: (item: TipBean) => {
        this.tipBeans = []
        this.locationToPoint(item.location, item.name);
      }
    })
  }

  @Builder
  preferSearchContent() {
    Column() {
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.preferSearch.split('|'), (item: string) => {
          Text(item)
            .onClick(() => {
              this.preferShow = false
              this.startSearch(item)
            })
            .gesture(LongPressGesture({ repeat: true }).onAction(() => {
              // 删除
              this.preferSearch = this.preferSearch.replace(`|${item}`, '')
            }))
            .fontSize(20)
            .margin({ left: 10, top:10 })
        })
      }
      Text("长按可以可删除")
        .fontColor(Color.Gray)
        .margin({top:20})
    }.width("100%")
    .borderRadius(10)
    .backgroundColor(Color.White)
    .visibility(this.preferShow ? Visibility.Visible : Visibility.None)
  }

  /**
   * 功能区组件
   */
  private iconSize = 30

  @Builder
  funcAreaComponent() {
    Column({ space: 16 }) {
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
      Image($r('app.media.icon_random'))
        .width(this.iconSize)
        .height(this.iconSize)
        .onClick(() => {
          this.funcClick(5)
        })
      Image($r('app.media.icon_setting'))
        .width(this.iconSize)
        .height(this.iconSize)
        .onClick(() => {
          this.funcClick(6)
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

