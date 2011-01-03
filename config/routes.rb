Expenses::Application.routes.draw do
  resources :transactions, :except => [:show, :new]
  resources :categories
  root :to => "transactions#index"
end
