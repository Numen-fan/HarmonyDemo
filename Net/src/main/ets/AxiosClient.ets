import { AxiosRequestHeaders, AxiosResponse } from "@ohos/axios";
import { AxiosHttpRequest } from './AxiosHttpRequest';
import { HttpRequestConfig } from './InterceptorHooks';
import { errorHandler, showToast } from './Utils';

export const axiosClient = new AxiosHttpRequest({
  baseURL: "/api",
  timeout: 10 * 1000,
  checkResultCode: false,
  headers: {
    'Content-Type': 'application/json'
  } as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      // 在发送请求之前做一些处理，例如打印请求信息
      console.debug('网络请求Request 请求方法:', `${config.method}`);
      console.debug('网络请求Request 请求链接:', `${config.url}`);
      console.debug('网络请求Request Params:', `\n${JSON.stringify(config.params)}`);
      console.debug('网络请求Request Data:', `${JSON.stringify(config.data)}`);
      axiosClient.config.showLoading = config.showLoading
      if (config.showLoading) {
        // showLoadingDialog("加载中...")
      }
      if (config.checkLoginState) {
        // let hasLogin = await StorageUtils.get(StorageKeys.USER_LOGIN, false)
        // console.debug('网络请求Request 登录状态校验>>>', `${hasLogin.toString()}`);
        // if (hasLogin) {
        //   return config
        // } else {
        // if (config.needJumpToLogin) {
        //   Router.push(RoutePath.TestPage)
        // }
        // throw new AxiosError("请登录","-100")
        // throw new Error("请登录")
        // }
      }
      return config;
    },
    requestInterceptorCatch: (err) => {
      console.error("网络请求RequestError", err.toString())
      // if (axiosClient.config.showLoading) {
      //   hideLoadingDialog()
      // }
      return err;
    },
    responseInterceptor: (response: AxiosResponse) => {
      //优先执行自己的请求响应拦截器，在执行通用请求request的
      if (axiosClient.config.showLoading) {
        // hideLoadingDialog()
      }
      console.debug('网络请求响应Response:', `\n${JSON.stringify(response.data)}`);
      if (response.status === 200) {
        let config = response.config as HttpRequestConfig
        const checkResultCode = config.checkResultCode
        if (checkResultCode && response.data.errorCode != 0) {
          showToast(response.data.errorMsg)
          return Promise.reject(response)
        }
        return Promise.resolve(response.data);
      } else {
        return Promise.reject(response);
      }
    },
    responseInterceptorCatch: (error) => {
      if (axiosClient.config.showLoading) {
        // hideLoadingDialog()
      }
      console.error("网络请求响应异常", error.toString())
      errorHandler(error);
      return Promise.reject(error);
    },
  }
});
