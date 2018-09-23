Rails.application.routes.draw do
  resources :service
  post 'service/contact'
  post  'service/metaget', to: 'service#metaget', as: 'service_metaget'
  post 'service/create'
  root to: "service#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
