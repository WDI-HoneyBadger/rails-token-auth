Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/cups", to: "cups#index"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show"
  post "/login", to: "sessions#create"
end
