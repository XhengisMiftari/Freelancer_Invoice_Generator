// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import InvoicePerformanceController from "./invoice_performance_controller"

application.register("invoice-performance", InvoicePerformanceController)
