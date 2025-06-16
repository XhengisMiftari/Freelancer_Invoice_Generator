import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("✅ InvoicePerformanceController connected")

    const ctx = this.element.getContext("2d")
    const labels = JSON.parse(this.element.dataset.invoicePerformanceLabels)
    const values = JSON.parse(this.element.dataset.invoicePerformanceValues)

    console.log("Labels:", labels)
    console.log("Values:", values)

    new Chart(ctx, {
      type: 'line', // ✅ Changed from 'bar' to 'line'
      data: {
        labels: labels,
        datasets: [{
          label: 'Invoices per Month',
          data: values,
          borderColor: 'rgba(75, 192, 192, 1)',
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          fill: true,
          tension: 0.3, // curved lines
          pointRadius: 5,
          pointHoverRadius: 7
        }]
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true,
            stepSize: 1
          }
        }
      }
    })
  }
}
