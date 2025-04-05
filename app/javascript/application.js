// Turbo Rails
import { Turbo } from "@hotwired/turbo-rails";
Turbo.setFormMode("optin");

// Stimulus Controllers
import "controllers";

// Helpers
import { checkAlerts, createAlert } from "helpers/alerts";

// Alerts
checkAlerts();
setInterval(function () {
  checkAlerts();
}, 2400);

window.createAlert = createAlert;
