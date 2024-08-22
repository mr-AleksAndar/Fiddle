import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

document.addEventListener('turbo:load', () => {
  console.log('Turbo loaded, reinitializing controllers');

  // Stimulus should automatically reconnect controllers for any new content loaded by Turbo.
  // However, if you need custom JavaScript reinitialization, do it here.
  
  // For example, you might manually call initialization functions for third-party libraries.
});