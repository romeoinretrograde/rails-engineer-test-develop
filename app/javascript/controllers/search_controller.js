import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log("Search controller connected")
  }

  submit() {
    console.log("Submit called")
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      console.log("Submitting form")
      const form = this.element.querySelector('form')
      if (form) {
        form.requestSubmit()
      }
    }, 300)
  }
}
