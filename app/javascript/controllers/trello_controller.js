// trello_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Trello controller connected")
    this.loadTrelloEmbedScript()
  }

  loadTrelloEmbedScript() {
    const scriptId = 'trello-embed-script'
    if (!document.getElementById(scriptId)) {
      const script = document.createElement('script')
      script.id = scriptId
      script.src = "https://p.trellocdn.com/embed.min.js"
      script.async = true
      document.body.appendChild(script)
    } else {
      // Reinitialize the script if it's already present
      if (window.TrelloCards && typeof window.TrelloCards.initialize === 'function') {
        window.TrelloCards.initialize()
      }
    }
  }
}