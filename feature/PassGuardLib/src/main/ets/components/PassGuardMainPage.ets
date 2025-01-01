import { PassGuardInput,OHGmSM2,OHGmSM4 } from 'passguardlibrary';
import router from '@ohos.router';
import '../pages/BWPage'
import '../pages/GMSSLDemoPage'
import '../pages/WebPassGuardPage'
import '../pages/RawArgPage'
import { BusinessError } from '@ohos.base';
import { ComponentContent } from "@ohos.arkui.node";

class Params {
  text: string = ""
  constructor(text: string) {
    this.text = text;
  }
}

@Builder
function buildText(params: Params) {


  Column() {
    Text(params.text)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({bottom: 36})
  }.backgroundColor('#FFF0F0F0')
}

@Entry({routeName:'PassGuardMainPage'})
@Component
export struct PassGuardMainPage {
  @State message: string = "hello"

  @State tipsTxt: string = "";

  controller1: TextInputController = new TextInputController();
  @Prop m_isOrder: boolean = true; //按键乱序
  @Prop m_inputAType: number = 0//键盘Type 0 字母键盘  2字母数字键盘 3特殊字符键盘 4纯数字键盘
  @Prop m_numKBType: number = 0; //键盘Type设置为4时 小选择 0 默认 1 小数点 2 身份证 X
  @Prop inInputValue1: string = ""; //输入框inputValue
  @Prop outputpwdn1: string = ""; //密文输出 json格式

  @Prop dInput1: string = "12345678901234567890123456789012"; //sm4 加密随机数
  @Prop dm_inputX: string = "1093A047C5CBF48283EC7A210703F3FF9EA4448DC15D56B4CD82FCB27DAD2D45"; //sm2加密公钥X
  @Prop dm_inputY: string = "F2BB0BF953BCEBB635D9D34E473ECEFC9F25880EB1669F94DE050A29AC86F308"; //sm2 加密公钥Y
  @Prop m_keyP: string = 'KeyP'; //键盘唯一ID
  @Prop m_mode: boolean = true //明密文模式
  @Prop nAbcData: string = "QmJpRnV6cjlHdHFKZm1uZHdlVWJOWDAyNGxXdlNDRmNiME9tM2ZTUmcyaTdQQXpKeGZLcjRpblVocGt6Ui85cXpCSG92M1BNZWJGdnovUnJsZG1tbzJ2U3ZENzBEM1pJSXlXRUE0OWhmSDcydDZZQ2dER25WSVVnUWJkWU84K2FtbldKNlpCZUdCNTlYL0tTRnRhOURQOXp1VXZhd2twM0ZxU2xROGtpV0RVPXsiaWQiOjAsInR5cGUiOiJ0ZXN0IiwicGxhdGZvcm0iOjMsIm5vdGJlZm9yZSI6IjIwMjQwMTI0Iiwibm90YWZ0ZXIiOiIyMDI0MDcyNCJ9"
  @Prop m_inputFilter: string = "^[A-Za-z0-9]+$" //输入中字符正则过滤
  @Prop m_inputFilterEnd: string = "^[A-Za-z0-9]{3,15}$" //输入完 ismatch 返回正则验证结果
  @Prop m_iMaxLen: number = 20 //最大输入限制
  @Prop m_iPresStyle: number = 1 //按键动画 0 没有动画 1按键动画
  @Prop m_ShowACDone: boolean = true //是否显示 键盘右上角收回三角按钮
  @Prop m_hasStatus: boolean = true // 按键状态 true 有按键状态
  @Prop m_placeholder: string = "密码安全输入" //设置placeholder
  @Prop m_autoDoneKB: boolean = true // 收起按键自动收起键盘
  inputLoseFocus:boolean = true;
  build() {

    Column() {
      Row() {
        Button("OH-RawArg")
          .key('button')
          .fontSize(20)
          .onClick(() => {
            router.pushNamedRoute({ name: 'RawArgPage'});
          })
          .onFocus(()=> {
            this.inputLoseFocus = false
          }).onBlur(()=> {
            this.inputLoseFocus = true
        })
      }.height(30)
      Blank().height(20)
      Button('OH-国密报文加密演示页面')
        .fontSize(20)
        .onClick(() => {
          router.pushNamedRoute({ name: 'BWPage' });
        }).height(30)

      Blank().height(20)
      Button('OH-GMSSL演示页面')
        .key("button0")
        .fontSize(20)
        .onClick(() => {
          router.pushNamedRoute({ name: 'GMSSLDemoPage' });
        }).height(30)

      Blank().height(20)
      Button('OH-Web调用原生键盘演示页面')
        .fontSize(20)
        .onClick(() => {
          router.pushNamedRoute({name: 'WebPassGuardPage' });
        }).height(30)

      Blank().height(20)
      Text('银行密码安全键盘:');
      Row() {
        PassGuardInput({
          m_mode: this.m_mode,
          m_autoDoneKB: this.m_autoDoneKB,
          m_keyP: this.m_keyP,
          m_inputFilter: this.m_inputFilter,
          m_inputFilterEnd: this.m_inputFilterEnd,
          m_isOrder: this.m_isOrder,
          m_inputAType: this.m_inputAType,
          m_numKBType: this.m_numKBType,
          m_ShowACDone: this.m_ShowACDone,
          //cancelButtonStyle: { style: CancelButtonStyle.CONSTANT },
          cancelButtonStyle:{style:CancelButtonStyle.CONSTANT,icon:{size:24,src:$r('app.media.icon')}},
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
            console.log("onInputChanged:" + inputValue + "-pwd:" + pwd);
            this.tipsTxt = "onInputChanged：" + inputValue + "\r\npwd:" + pwd;
          }
        ,
          onFocusAction: () => {
            //键盘首次获取焦点会触发
            console.log("kb show!!!");
            this.tipsTxt = "onFocusAction：" + this.outputpwdn1;
            ;
          },
          doneAction: () => {
            console.log("kb done!!!");
            // focusControl.requestFocus('button')
            this.tipsTxt = "doneAction:" + this.outputpwdn1;
          },
          onBlurAction: () => {
            console.log("kb onBlurAction!!!");
            // focusControl.requestFocus('button')
            this.tipsTxt = "onBlurAction:" + this.outputpwdn1;
          }
        }).height(40).width(180)
          .onFocus(() => {
            console.warn("聚焦")
          }).onBlur(() => {
          console.warn("失去焦点")
        })
        ;
        Blank().width(40).height(40)
        Button('主动X')
          .fontSize(20)
          .onClick(() => {
            this.inInputValue1 = ''
          }).height(40)
      }.align(Alignment.Center)

      Blank().height(10)
      Text(this.tipsTxt).fontSize(10);
      Blank().height(10)
      Button("click me")
        .onClick(() => {
          focusControl.requestFocus('KeyP');
          console.warn("KeyP")
          // let uiContext = this.getUIContext();
          // let promptAction = uiContext.getPromptAction();
          // let contentNode = new ComponentContent(uiContext, wrapBuilder(buildText), new Params(this.message));
          // try {
          //   promptAction.openCustomDialog(contentNode);
          // } catch (error) {
          //   let message = (error as BusinessError).message;
          //   let code = (error as BusinessError).code;
          //   console.error(`OpenCustomDialog args error code is ${code}, message is ${message}`);
          // };
        })
    }
    .width('90%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .onTouch((event?: TouchEvent) => {

      if (event) {
        if (event.type === TouchType.Down) {
          if (!this.inputLoseFocus) {
            focusControl.requestFocus('button0')
          }
          // console.warn("event.type === TouchType.Down")

        }
        if (event.type === TouchType.Up) {

        }
        if (event.type === TouchType.Move) {
        }
        if (event.type === TouchType.Cancel) {
        }
      }
    })
    .margin({ top: 20 })

  }
}