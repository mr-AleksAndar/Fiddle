# Pin npm packages by running ./bin/importmap
# config/importmap.rb
pin "@rails/ujs", to: "lib/rails-ujs.js"
pin "application", preload: true  # Points to app/javascript/application.js or main entry point
pin_all_from "app/javascript/controllers", under: "controllers"  # Loads all controllers automatically
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true