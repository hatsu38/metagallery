Rails.application.routes.draw do
  get 'service/index'
  root to: "service#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
