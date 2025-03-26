import { TipBean } from "./TipBean";

export class TipsResult {
  status: number = 0;
  info: string = '';
  count: number = 0;
  tips: Array<TipBean> = []
}