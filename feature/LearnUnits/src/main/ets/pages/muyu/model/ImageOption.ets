export class ImageOption {
  name: string = ''
  src: ResourceStr = ''
  min: number = 0
  max: number = 0

  constructor(name: string, src: ResourceStr, min: number, max: number) {
    this.name = name
    this.src = src
    this.min = min
    this.max = max
  }
}