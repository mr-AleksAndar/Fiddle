import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "controllers"  // This automatically loads your controllers folder
import Rails from "@rails/ujs"

Rails.start()

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
console.log('yo2')
// Optional: Reinitialize your JavaScript or Stimulus controllers on Turbo load
document.addEventListener('turbo:load', () => {
  console.log('Turbo loaded, reinitializing controllers2');

  // Stimulus should automatically reconnect controllers for any new content loaded by Turbo.
  // However, if you need custom JavaScript reinitialization, do it here.
  
  // For example, you might manually call initialization functions for third-party libraries.
});