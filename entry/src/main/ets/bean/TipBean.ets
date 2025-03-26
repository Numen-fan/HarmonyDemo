export class TipBean {
  id?: number
  name?: string
  district?: string
  adcode?: number
  location?: string
  address?: string

  constructor(id?: number, name?: string, district?: string, adcode?: number, location?: string, address?: string) {
    this.id = id;
    this.name = name;
    this.district = district;
    this.adcode = adcode;
    this.location = location;
    this.address = this.address;
  }
}