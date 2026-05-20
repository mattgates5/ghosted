Rails.application.routes.draw do
  resources :job_applications do
    collection do
      get :active
      get :archived
    end
  end
  root "job_applications#index"

  namespace :api do
    namespace :v1 do
      resources :job_applications, only: %i[index show create update destroy] do
        member do
          get :job_description
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
