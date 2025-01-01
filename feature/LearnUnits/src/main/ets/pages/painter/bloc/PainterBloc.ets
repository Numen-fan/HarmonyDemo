import { Line, Point } from "../model/Line";

export class PainterBloc {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  @Track lines: Line[] = [] // 线列表
  @Track context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @Track supportStrokeWidths: number[] = [1, 2, 4, 6, 8, 10]
  @Track supportColors: string[] =
    ['#ff000000', '#fff44336', '#ffff9800', '#ffffeb3b', '#ff4caf50', '#ff2196f3', '#ff3f51b5', '#ff9c27b0',
      '#ffe91e63',
      '#ff9e9e9e', '#ffff5252', '#ffffab40', '#ffffff00', '#ff69f0ae', '#ff448aff', '#ff536dfe', '#ffe040fb',
      '#ffff4081',
      '#889e9e9e', '#88ff5252', '#88ffab40', '#88ffff00', '#8869f0ae', '#88448aff', '#88536dfe', '#88e040fb',
      '#88ff4081',
      '#449e9e9e', '#44ff5252', '#44ffab40', '#44ffff00', '#4469f0ae', '#44448aff', '#44536dfe', '#44e040fb',
      '#44ff4081',
    ]
  @Track colorIndex: number = 0
  @Track strokeWidthIndex: number = 0
  @Track historyLines: Line[] = [] // 回退的历史线列表
  @Track lineCount = 0;
  @Track historyLineCount = 0;

  newLine(x: number, y: number) {
    let currentColor = this.supportColors[this.colorIndex]
    let currentStrokeWidth = this.supportStrokeWidths[this.strokeWidthIndex]
    // 新增一条线
    this.lines.push(new Line([new Point(x, y)], currentColor, currentStrokeWidth))
    this.updateCount()
  }

  updateLine(x: number, y: number) {
    // 取最后一条线
    let lastLineIndex = this.lines.length - 1;
    let lastLine = this.lines[lastLineIndex]
    let lastPoint = lastLine.points[lastLine.points.length - 1]
    let distance = Math.sqrt(Math.pow((x - lastPoint.x), 2) + Math.pow((y - lastPoint.y), 2))
    if (distance < 5) {
      return
    }
    lastLine.points.push(new Point(x, y))
    this.paint(this.context)
  }

  paint(canvas: CanvasRenderingContext2D) {
    canvas.clearRect(0, 0, this.context.width, this.context.height)
    for (let index = 0; index < this.lines.length; index++) {
      this.drawLine(canvas, this.lines[index])
    }
  }

  /**
   * 根据点集绘制线
   * @param canvas
   * @param line
   */
  drawLine(canvas: CanvasRenderingContext2D, line: Line) {
    canvas.strokeStyle = line.color
    canvas.lineWidth = line.strokeWidth
    canvas.beginPath()
    let count = line.points.length
    if (count === 1) {
      return
    }
    let first = line.points[0]
    canvas.moveTo(first.x, first.y)
    for (let index = 1; index < count; index++) {
      let cur = line.points[index]
      canvas.lineTo(cur.x, cur.y)
    }
    canvas.stroke()
  }

  clear(): void {
    this.lines = []
    this.paint(this.context)
  }

  changeStrokeWidth(index: number) {
    this.strokeWidthIndex = index
  }

  currentColor(): string | undefined {
    return this.supportColors[this.colorIndex]
  }

  changeColor(index: number) {
    this.colorIndex = index
  }

  private updateCount() {
    this.lineCount = this.lines.length
    this.historyLineCount = this.historyLines.length
  }

  revocation() {
    let line = this.historyLines.pop()
    if (line) {
      this.lines.push(line)
      this.updateCount()
    }
    this.paint(this.context)
  }

  back(): void {
    let line = this.lines.pop()
    if (line) {
      this.historyLines.push(line)
      this.updateCount()
    }
    this.paint(this.context)
  }
}