import { promptAction } from "@kit.ArkUI";
import { AxiosError } from "@ohos/axios";
import { CommonType } from "./InterceptorHooks";

export function showToast(msg: string) {
  promptAction.showToast({ message: msg })
}
export function errorHandler(error: CommonType) {

  if (error instanceof AxiosError) {
    switch (error.status) {
    // 401: 未登录
    // 未登录则跳转登录页面，并携带当前页面的路径
    // 在登录成功后返回当前页面，这一步需要在登录页操作。
      case 401:

        break;
    // 403 token过期
    // 登录过期对用户进行提示
    // 清除本地token和清空vuex中token对象
    // 跳转登录页面
      case 403:
        showToast("登录过期，请重新登录")
        // 清除token
        // localStorage.removeItem('token');
        break;
    // 404请求不存在
      case 404:
        showToast("网络请求不存在")
        break;

    // 其他错误，直接抛出错误提示
      default:
        showToast(error.message)
    }
  }
}