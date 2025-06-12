import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", (e) => {
      if (e.detail.success) {
        document.getElementById("clients_list_frame").reload()
      }
    })
  }
}
