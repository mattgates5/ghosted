Rails.application.routes.draw do
  resources :job_applications
  root "job_applications#index"

  namespace :api do
    namespace :v1 do
      resources :job_applications, only: %i[index show create update destroy]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
