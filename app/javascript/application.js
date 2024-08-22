// application.js

import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "controllers"
import Rails from "@rails/ujs"

Rails.start()

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }

// Optional: Reinitialize your JavaScript or Stimulus controllers on Turbo load
document.addEventListener('turbo:load', () => {
  console.log('Turbo loaded, reinitializing controllers');

  // Ensure Stimulus controllers, including TrelloController, are connected
  const application = window.Stimulus;
  const trelloController = application.getControllerForElementAndIdentifier(document, 'trello');

  if (!trelloController) {
    console.log('TrelloController is not connected. Connecting now...');
    // Manually connect the Trello controller if it's not connected
    const trelloElements = document.querySelectorAll('[data-controller="trello"]');
    trelloElements.forEach((element) => {
      application.getControllerForElementAndIdentifier(element, 'trello') || 
        application.controllers.push(new window.Stimulus.controllers['trello']({ element }));
    });
  } else {
    console.log('TrelloController is already connected.');
  }

  // Any other reinitialization logic you might need
});