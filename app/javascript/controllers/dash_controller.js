import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cards"]

  activate(event) {
    this.cardsTarget.querySelectorAll(".active")
                    .forEach(el => el.classList.remove("active"))
    event.currentTarget.classList.add("active")
  }
}
