// helpers/alerts.js
export function checkAlerts() {
  for (let i = 0; i < document.getElementsByClassName('alert').length; i++) {
      if (document.getElementsByClassName('alert')[i].style.display != 'none') {
          hideAlert(i);
      }
  }
}

export function hideAlert(i) {
  setTimeout(function() {
      if (!!document.getElementsByClassName('alert')[i]) {
          document.getElementsByClassName('alert')[i].style.display = 'none';
      }
  }, 2400);
}

export function createAlert(message) {
  let alert = document.createElement("p");
  let messageContent = document.createTextNode(message);
  alert.className = "alert";
  alert.appendChild(messageContent);
  document.body.appendChild(alert);
}