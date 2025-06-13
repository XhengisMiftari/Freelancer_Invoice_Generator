import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static values = {
    icon: String,
    alertTitle: String,
    alertHtml: String,
    confirmButtonText: String,
    showCancelButton: Boolean,
    cancelButtonText: String,
  };

  initSweetalert(event) {
  event.preventDefault(); // Prevent the form to be submited after the submit button has been clicked

  Swal.fire({
    icon: this.iconValue,
    title: this.alertTitleValue,
    html: this.alertHtmlValue,
    confirmButtonText: this.confirmButtonTextValue,
    showCancelButton: this.showCancelButtonValue,
    cancelButtonText: this.cancelButtonTextValue,
    reverseButtons: true
  }).then((result) => {
          if (result.isConfirmed) {
            document.querySelector('.remove').submit()
          }
        })
        .catch(event.preventDefault())
  }
}
