import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="project-performance"
export default class extends Controller {
  connect() {
    console.log("✅ ProjectPerformanceController connected")

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
    console.log("🔄 Fetching project data from:", url)

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
              label: 'Projects Created',
              data: data.values,
              borderColor: 'rgba(153, 102, 255, 1)',
              backgroundColor: 'rgba(153, 102, 255, 0.2)',
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
        console.error("❌ Chart load error:", error)
      })
  }
}
