// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
//eagerLoadControllersFrom("controllers", application)
// eagerLoadControllersFrom("controllers", application)
// import InvoicePerformanceController from "./invoice_performance_controller"
// application.register("invoice-performance", InvoicePerformanceController)

// import ClientPerformanceController from "./client_performance_controller"
// application.register("client-performance", ClientPerformanceController)

// import ProjectPerformanceController from "./project_performance_controller"
// application.register("project-performance", ProjectPerformanceController)

//  import MiniChartController from "./mini_chart_controller"
//  application.register("mini-chart", MiniChartController)
