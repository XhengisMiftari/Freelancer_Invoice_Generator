import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    this.chart = null
    this.currentYear = parseInt(this.data.get("currentYear"))
    this.chartUrl = this.data.get("url")
    this.ctx = this.element.querySelector("canvas").getContext("2d")
    this.yearLabel = this.element.querySelector("#year-label")

    this.loadChart(this.currentYear)
  }

  previousYear() {
    this.currentYear -= 1
    this.loadChart(this.currentYear)
  }

  nextYear() {
    this.currentYear += 1
    this.loadChart(this.currentYear)
  }

  loadChart(year) {
    fetch(`${this.chartUrl}?year=${year}`)
      .then(response => response.json())
      .then(data => {
        this.yearLabel.textContent = data.year

        if (this.chart) this.chart.destroy()

        this.chart = new Chart(this.ctx, {
          type: 'line',
          data: {
            labels: data.labels,
            datasets: [{
              label: 'Invoices per Month',
              data: data.values,
              borderColor: 'rgba(75, 192, 192, 1)',
              backgroundColor: 'rgba(75, 192, 192, 0.2)',
              tension: 0.3,
              fill: true,
              pointRadius: 5
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
      })
      .catch(err => {
        console.error("Chart load error:", err)
      })
  }
}
