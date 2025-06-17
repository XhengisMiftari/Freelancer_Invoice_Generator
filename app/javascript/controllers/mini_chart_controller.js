import { Controller } from "@hotwired/stimulus"
import { Chart, LineController, LineElement, PointElement, LinearScale } from "chart.js"

Chart.register(LineController, LineElement, PointElement, LinearScale)

export default class extends Controller {
  connect() {
    const values = JSON.parse(this.data.get("values") || "[]")
    if (!values.length) return

    const ctx = this.element.querySelector("canvas")?.getContext("2d")
    if (!ctx) return

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: values.map((_, i) => i + 1),
        datasets: [{
          data: values,
          borderColor: 'rgba(75, 192, 192, 1)',
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          fill: true,
          tension: 0.4,
          pointRadius: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          x: { display: false },
          y: { display: false }
        }
      }
    })
  }
}
