Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "teams#new"

  resources :teams, param: :uuid, only: [:new, :create, :show] do
    resources :team_users, only: [:create, :show]
  end

  namespace :api do
    namespace :v1 do
      resource :team, only: [] do
        resources :team_users, only: [:index, :create]
        resource :status, only: [:show]
        resources :status_updates, only: [:create]
      end
    end
  end
end
