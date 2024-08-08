Rails.application.routes.draw do
  get 'posts/index_lazy', to: 'posts#index_lazy'
  resources :posts
end