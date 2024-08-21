Rails.application.routes.draw do
  resources :users
  resource :session, only: [:new, :create, :destroy]

  resources :cards do
    patch 'reveal_scores', on: :member
    patch 'hide_scores', on: :member
    resources :scores, only: [:create, :update, :destroy] # Nesting scores under cards
  end

  root "cards#index"
end