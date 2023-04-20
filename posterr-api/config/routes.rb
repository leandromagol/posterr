Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'homepage', to: 'homepage#index'
  post 'posts', to: 'posts#store_post'
  post 'posts/repost', to: 'posts#store_repost'
  post 'posts/quote_post', to: 'posts#store_quote_post'
  get 'profile/:id', to: 'profile#index'
  get 'feed/:id', to: 'profile#feed'

end
