Rails.application.routes.draw do
  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :cards do
    post 'show_scores', on: :member
  end
  root "cards#index"
end