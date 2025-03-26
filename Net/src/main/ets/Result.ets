export class Result<T> {
  code: number = -1;
  msg: string = '';
  data: T | null = null;
}