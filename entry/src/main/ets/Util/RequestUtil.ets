import { AxiosHeaders } from "@ohos/axios";
import { axiosClient } from "net";
import { RouteResponse } from "../bean/RoutePlan";
import { TipsResult } from "../bean/TipsResult";
import { Constants } from "./Constants";


const commonHeader: AxiosHeaders = new AxiosHeaders()

export class RequestUtil {
  static async queryForKeyword(keywords: string, longitude?: number, latitude?: number,
    adcode?: number): Promise<TipsResult> {
    return axiosClient.get<TipsResult>({
      url: Constants.BASE_URL + Constants.INPUT_TIPS_URL,
      params: {
        "key": Constants.WEB_KEY,
        "keywords": keywords,
        "location": longitude + "," + latitude,
        "city": adcode
      },
      headers: commonHeader
    })
  }

  //116.481028,39.989643  116.465302,40.004717
  static async queryRoute(origin: string, destination: string, type: string = 'driving'): Promise<RouteResponse> {
    return axiosClient.get<RouteResponse>({
      url: Constants.BASE_URL + Constants.ROUTE_PLAN_URl + type,
      params: Object({
        "key": Constants.WEB_KEY,
        "origin": origin,
        "destination": destination,
        "extensions": "base",
        "output": "json"
      })
    , headers: commonHeader
    })
  }
}