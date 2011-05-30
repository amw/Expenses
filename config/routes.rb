Expenses::Application.routes.draw do
  resources :transactions, :except => [:show, :new]
  resources :categories, :only => [:show, :update]

  resources :charts, :only => [] do
    collection do
      get :pie
      get :trends
    end
  end

  match '/' => redirect("/transactions")
end
