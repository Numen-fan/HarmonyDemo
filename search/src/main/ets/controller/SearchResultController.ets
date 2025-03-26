@Observed
export class SearchResultController {
  isSubmit: boolean = false

  submit() {
    this.isSubmit = true
  }
}