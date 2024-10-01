import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Trello controller connected")
    this.loadTrelloEmbedScript()

    // Add an event listener for Turbo to reinitialize Trello after Turbo loads
    document.addEventListener('turbo:load', this.loadTrelloEmbedScript)
  }

  disconnect() {
    // Remove the event listener when the controller is disconnected to avoid memory leaks
    document.removeEventListener('turbo:load', this.loadTrelloEmbedScript)
  }

  loadTrelloEmbedScript = () => {
    const scriptId = 'trello-embed-script'

    // Check if the script is already present in the document
    if (!document.getElementById(scriptId)) {
      const script = document.createElement('script')
      script.id = scriptId
      script.src = "https://p.trellocdn.com/embed.min.js"
      script.async = true
      document.body.appendChild(script)
    } else {
      // If the script is already loaded, reinitialize the Trello cards
      if (window.TrelloCards && typeof window.TrelloCards.initialize === 'function') {
        window.TrelloCards.initialize()
      }
    }
  }
}