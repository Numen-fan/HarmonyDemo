import { CommonConstants } from '../common/constant/CommonConstant';
import WebView from '@ohos.web.webview';
import JSBridge from '../common/utils/JsBridge';
import display from '@ohos.display';
import Logger from '../common/utils/Logger';
import { PassGuardInput } from '@ohos/libPassGuardSDK';

function drawCharsA(length:number) {
  console.log("####+++"+length)
  let result = '';
  for (let i = 0; i < length; i++) {
    result += '*';
  }
  return result;
}

@Entry({routeName: 'WebPassGuardPage'})
@Component

struct WebPassGuardPage {

  @StorageLink('isClick') isClick: boolean = false;
  @StorageLink('tel') phoneNumber: string = '';
  @StorageLink('proportion') proportion: number = 0;

  controller1: TextInputController = new TextInputController();
  @Prop m_isOrder: boolean = true; //按键乱序
  @Prop m_inputAType: number = 0//键盘Type 0 字母键盘  2字母数字键盘 3特殊字符键盘 4纯数字键盘
  @Prop m_numKBType: number = 0; //键盘Type设置为4时 小选择 0 默认 1 小数点 2 身份证 X
  @Prop inInputValue1: string = ""; //输入框inputValue
  @Prop outputpwdn1: string = ""; //密文输出 json格式

  @Prop dInput1: string = "12345678901234567890123456789012"; //sm4 加密随机数
  @Prop dm_inputX: string = "1093A047C5CBF48283EC7A210703F3FF9EA4448DC15D56B4CD82FCB27DAD2D45"; //sm2加密公钥X
  @Prop dm_inputY: string = "F2BB0BF953BCEBB635D9D34E473ECEFC9F25880EB1669F94DE050A29AC86F308"; //sm2 加密公钥Y
  @Prop m_keyP: string = 'webPwdKey'; //键盘唯一ID
  @Prop m_mode: boolean = true //明密文模式
  @Prop nAbcData: string = "QmJpRnV6cjlHdHFKZm1uZHdlVWJOWDAyNGxXdlNDRmNiME9tM2ZTUmcyaTdQQXpKeGZLcjRpblVocGt6Ui85cXpCSG92M1BNZWJGdnovUnJsZG1tbzJ2U3ZENzBEM1pJSXlXRUE0OWhmSDcydDZZQ2dER25WSVVnUWJkWU84K2FtbldKNlpCZUdCNTlYL0tTRnRhOURQOXp1VXZhd2twM0ZxU2xROGtpV0RVPXsiaWQiOjAsInR5cGUiOiJ0ZXN0IiwicGxhdGZvcm0iOjMsIm5vdGJlZm9yZSI6IjIwMjQwMTI0Iiwibm90YWZ0ZXIiOiIyMDI0MDcyNCJ9"
  @Prop m_inputFilter: string = "^[A-Za-z0-9]+$" //输入中字符正则过滤
  @Prop m_inputFilterEnd: string = "^[A-Za-z0-9]{3,15}$" //输入完 ismatch 返回正则验证结果
  @Prop m_iMaxLen: number = 20 //最大输入限制
  @Prop m_iPresStyle: number = 0 //按键动画 0 没有动画 1按键动画
  @Prop m_ShowACDone: boolean = true //是否显示 键盘右上角收回三角按钮
  @Prop m_hasStatus: boolean = true // 按键状态 true 有按键状态
  @Prop m_placeholder: string = "密码安全输入" //设置placeholder
  @Prop m_autoDoneKB: boolean = true // 收起按键自动收起键盘


  // @State chargeTip: Resource = "chargeTip";
  webController: WebView.WebviewController = new WebView.WebviewController();


  private jsBridge: JSBridge = new JSBridge(this.webController);

  aboutToAppear() {
    display.getAllDisplays((err, displayClass: display.Display[]) => {
      if (err.code) {
        Logger.error('SelectContact Page', 'Failed to obtain all the display objects. Code: ' + JSON.stringify(err));
        return;
      }
      this.proportion = displayClass[0].densityDPI / CommonConstants.COMMON_VALUE;
      Logger.info('Succeeded in obtaining all the display objects. Data: ' + JSON.stringify(displayClass));
    });
  }

  build() {
    Column() {
      Row(){
        Button().width(0).height(0).key('WebTextFocusButton')
        PassGuardInput({
          defaultFocusP:true,
          widthP:0,
          heightP:0,
          m_mode: this.m_mode,
          m_autoDoneKB: this.m_autoDoneKB,
          m_keyP: this.m_keyP,
          m_inputFilter: this.m_inputFilter,
          m_inputFilterEnd: this.m_inputFilterEnd,
          m_isOrder: this.m_isOrder,
          m_inputAType: this.m_inputAType,
          m_numKBType: this.m_numKBType,
          m_ShowACDone: this.m_ShowACDone,
          cancelButtonStyle: { style: CancelButtonStyle.CONSTANT },
          // cancelButtonStyle:{style:CancelButtonStyle.CONSTANT,icon:{size:24,src:$r('app.media.shift')}},
          m_iPresStyle: this.m_iPresStyle,
          inputValue: $inInputValue1,
          m_abcData: this.nAbcData,
          m_outputPwd: $outputpwdn1,
          m_placeholder: this.m_placeholder,
          m_iMaxLen: this.m_iMaxLen,
          m_hasStatus: this.m_hasStatus,
          m_input1: $dInput1,
          m_inputX: this.dm_inputX,
          m_inputY: this.dm_inputY,
          onInputChanged: (inputValue: string, pwd: string) => {
            console.log("####++"+pwd)
            let str = 'document.getElementById(\'phone\').value =\'' +drawCharsA(Number(JSON.parse(pwd).length))+'\''
            this.webController.runJavaScript(str);
            let str2 = 'document.getElementById(\'crypto\').value =\'' +pwd+'\''
            this.webController.runJavaScript(str2);
          }
        ,
          onFocusAction: () => {
            //键盘首次获取焦点会触发
            console.log("kb show!!!");
            console.log("kb show!!!");
            this.dInput1 = "12345678901234567890123456789012";
            this.dm_inputX = "1093A047C5CBF48283EC7A210703F3FF9EA4448DC15D56B4CD82FCB27DAD2D45";
            this.dm_inputY = "F2BB0BF953BCEBB635D9D34E473ECEFC9F25880EB1669F94DE050A29AC86F308";
          },
          doneAction: () => {
            console.log("kb done!!!");
            focusControl.requestFocus('button')
            // this.webController.loadUrl($rawfile('MainPage_2.html'))
          },
          onBlurAction: () => {
            console.log("kb onBlurAction!!!");
            focusControl.requestFocus('button')
          }
        }).height(0).width(0);
        Web({
          src: $rawfile('MainPage.html'),
          controller: this.webController
        })
          .javaScriptAccess(true)
          .javaScriptProxy(this.jsBridge.javaScriptProxy)
          .height("500vp")
          .onPageBegin(() => {
            this.jsBridge.initJsBridge();
          })
      }
    }.width('90%')
    .height(CommonConstants.FULL_SIZE)
    .backgroundColor("#00ff00")
  }
}