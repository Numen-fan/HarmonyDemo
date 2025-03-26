export class HotBean {
  name?: string //名字
  label?: HotItemBean

  constructor(name: string, label?: HotItemBean) {
    this.name = name
    this.label = label
  }
}

class HotItemBean {
  name?: string //标签名字
  bgColor?: ResourceColor //标签背景颜色
  src?: string //图片资源
}