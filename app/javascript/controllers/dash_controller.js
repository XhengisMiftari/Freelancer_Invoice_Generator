import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cards"]

  activate(event) {
    this.cardsTarget.querySelectorAll(".active")
                    .forEach(el => el.classList.remove("active"))
    event.currentTarget.classList.add("active")
  }
}
// the action "activate" is run after clicking the "active" css class -> Turbo does GET request for dashboard -> routes.rb
