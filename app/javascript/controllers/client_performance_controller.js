import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("✅ ClientPerformanceController connected")

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
    const url = `${this.chartUrl}?year=${year}`
    console.log("🔄 Fetching client data from:", url)

    fetch(url)
      .then(response => response.json())
      .then(data => {
        this.yearLabel.textContent = data.year

        if (this.chart) this.chart.destroy()

        this.chart = new Chart(this.ctx, {
          type: 'line',
          data: {
            labels: data.labels,
            datasets: [{
              label: 'Clients Created',
              data: data.values,
              borderColor: 'rgba(255, 159, 64, 1)',
              backgroundColor: 'rgba(255, 159, 64, 0.2)',
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
      .catch(error => {
        console.error("❌ Client chart load error:", error)
      })
  }
}
