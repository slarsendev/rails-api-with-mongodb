Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products, except: %i(new edit show)
  get '/calculate', to: 'products#calculate'
  get '/show', to: 'products#show'
end
