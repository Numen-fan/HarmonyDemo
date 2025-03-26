export class HotItemAttribute {
  fontColor?: ResourceColor
  fontSize?: number | string | Resource = 14
  backgroundColor?: ResourceColor
  fontWeight?: number | FontWeight | string
  labelSize?: Length = 10
  labelMarginRight: Length = 10
  columnsTemplate?: string = "1fr 1fr"
  rowsGap?: Length = 10
  labelFontColor?: ResourceColor
  labelFontSize?: number | string | Resource = 14
  labelFontWeight?: number | FontWeight | string
  labelPadding?: Padding | Length | LocalizedPadding
}