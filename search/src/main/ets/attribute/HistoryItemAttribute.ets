import { LengthMetrics } from "@kit.ArkUI"

export class HistoryItemAttribute {
  fontColor?: ResourceColor
  fontSize?: number | string | Resource = 14
  backgroundColor?: ResourceColor = "#e8e8e8"
  padding?: Padding | Length | LocalizedPadding = {
    left: 10,
    right: 10,
    top: 5,
    bottom: 5
  }
  borderRadius?: Length | BorderRadiuses | LocalizedBorderRadiuses = 5
  fontWeight?: number | FontWeight | string
  main?: LengthMetrics = LengthMetrics.vp(10)
  cross?: LengthMetrics = LengthMetrics.vp(10)
}