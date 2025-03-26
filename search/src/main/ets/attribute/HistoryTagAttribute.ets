export class HistoryTagAttribute {
  title?: string | Resource = "历史搜索"
  fontColor?: ResourceColor = "#222222"
  fontSize?: number | string | Resource = 16
  fontWeight?: number | FontWeight | string = FontWeight.Bold
  margin?: Margin | Length | LocalizedMargin = { top: 20 }
  deleteSrc?: PixelMap | ResourceStr | DrawableDescriptor = $r("app.media.delete")
  imageWidth?: Length = 20
  imageHeight?: Length = 20
  height?: Length = 20
}