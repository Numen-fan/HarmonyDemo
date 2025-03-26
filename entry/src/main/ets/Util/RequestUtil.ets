import { AxiosHeaders } from "@ohos/axios";
import { axiosClient } from "net";
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
}