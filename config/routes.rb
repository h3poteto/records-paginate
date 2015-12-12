Rails.application.routes.draw do
  mount Peek::Railtie => '/peek'
  resources :records, only: :index do
    collection do
      get :search
    end
  end

  root to: "records#index"
end
