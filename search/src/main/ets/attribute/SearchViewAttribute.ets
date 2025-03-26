export class SearchViewAttribute {
  placeholder?: ResourceStr = "请输入搜索内容"
  placeholderColor?: ResourceColor
  placeholderFont?: Font
  value?: string
  textFont?: Font
  fontColor?: ResourceColor
  textAlign?: TextAlign
  icon?: string
  copyOption?: CopyOptions
  height?: Length = 40
  margin?: Margin | Length | LocalizedMargin
  searchIcon?: IconOptions | SymbolGlyphModifier
  cancelButton?: CancelButtonOptions | CancelButtonSymbolOptions
  caretStyle?: CaretStyle
  enableKeyboardOnFocus?: boolean
  selectionMenuHidden?: boolean
  type?: SearchType
  maxLength?: number
  enterKeyType?: EnterKeyType
  onSubmit?: (value: string) => void
}