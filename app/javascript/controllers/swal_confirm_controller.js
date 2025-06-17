import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {

  connect() {
    // capture:true = run BEFORE Rails-UJS / Turbo handlers
    this.element.addEventListener("click", this.handleClick, true)
    this.element.addEventListener("submit", this.handleSubmit, true)
  }
  // disconnect() → tidy up when the element gets unloaded.
  disconnect() {
    this.element.removeEventListener("click", this.handleClick, true)
    this.element.removeEventListener("submit", this.handleSubmit, true)
  }

  // CLICK HANDLER – links & buttons
  handleClick = async (e) => {
    // Find the closest element that needs confirmation
    const el = e.target.closest("[data-confirm], [data-turbo-confirm]")
    if (!el) return          // nothing to confirm

    e.preventDefault()        // stop native action

    const message =
      el.dataset.turboConfirm || el.dataset.confirm || "Are you sure?"

    const body = el.dataset.swalText      // optional second line
    // const icon = el.dataset.swalIcon || "info"
    const okLabel = el.dataset.swalConfirmText || "Yes"
    const cancel  = el.dataset.swalCancelText  || "Cancel"
    const customImg = document.querySelector('meta[name="swal-logo"]').content;

      // Show modal and wait
    const { isConfirmed } = await Swal.fire({
      title: message,
      text: body,
      // icon,
      imageUrl: customImg,
      imageWidth: 180,
      imageHeight: 180,
      showCancelButton: true,
      confirmButtonText: okLabel,
      confirmButtonColor: '#5FA8A4',
      cancelButtonText: cancel,
      cancelButtonColor: '#B8CFCE',
      reverseButtons: true,
      focusCancel: true,
      background: '#EAEFEF'
    })

    if (!isConfirmed) return   // user clicked “Cancel”

     // Remove the attribute to avoid an infinite loop
    el.removeAttribute("data-confirm")
    el.removeAttribute("data-turbo-confirm")

    // Re-trigger the intended action
    if (el.tagName === "A") {
      // Preserve Turbo behaviour
      Turbo.visit(el.href, { action: "advance" })
    } else {
      // button_to => hidden form; a second click submits it
      el.click()
    }
    if (
      el.tagName === "A" &&
      !el.dataset.turboMethod &&   // no verb override → normal GET ok
      !el.dataset.method
    ) {
      Turbo.visit(el.href, { action: "advance" })
    }else {
      // data-turbo-method / data-method / <button> / <form>
      el.click()
      }
    }
  // SUBMIT HANDLER – forms with confirmation
  handleSubmit = async (e) => {
    const form = e.target
    const message =
      form.dataset.turboConfirm || form.dataset.confirm || null
    if (!message) return
 // STYLE SWAL HOW YOU LIKE IT
    const body = form.dataset.swalText      // optional second line
    const icon = form.dataset.swalIcon || "warning"
    const okLabel = form.dataset.swalConfirmText || "Yes"
    const cancel = form.dataset.swalCancelText  || "Cancel"

    e.preventDefault()

    const { isConfirmed } = await Swal.fire({
      title: message,
      text: body,
      icon,
      showCancelButton: true,
      confirmButtonText: okLabel,
      cancelButtonText: cancel,
      reverseButtons: true,
      focusCancel: true,
    })

    if (!isConfirmed) return

    // Avoid second modal, then submit
    form.removeAttribute("data-confirm")
    form.removeAttribute("data-turbo-confirm")
    form.requestSubmit()
  }
}
