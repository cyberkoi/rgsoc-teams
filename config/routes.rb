RgsocTeams::Application.routes.draw do
  resources :job_offers

  resources :events

  # FIXME Accessing season this early breaks `rake db:create RAILS_ENV=test` on CI
  # if Season.current.started?
    root to: 'activities#index'
  # else
  #   root to: 'users#index'
  # end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  concern :has_roles do
    resources :roles, only: [:new, :create, :destroy]
  end

  get 'users/info', to: 'users_info#index'
  resources :users, except: :new, concerns: :has_roles
  resources :sources, only: :index
  resources :comments, only: :create
  resources :conferences
  resources :attendances
  resources :contributors, only: :index

  namespace :applications do
    get 'students/:id', to: 'students#show', as: 'student'
    get 'teams/:id', to: 'teams#show', as: 'team'
    get 'todos', to: 'todos#index', as: 'todos'
  end
  resources :applications
  resources :ratings

  resources :application_drafts, except: [:show, :destroy] do
    member do
      put :apply
      get :check
      put :prioritize
      put :sign_off
    end
  end

  get 'application', to: 'applications#new'
  get 'application_forms', to: 'applications#new'
  post 'application_forms', to: 'applications#create'

  get 'apply', to: 'application_drafts#new', as: :apply

  get 'teams/info', to: 'teams_info#index'
  resources :teams, concerns: :has_roles do
    resources :join, only: [:new, :create]
    resources :sources
  end

  get 'calendar/index', as: :calendar
  get 'calendar/events', to: 'calendar#events'

  get 'pages/:page', to: 'pages#show', as: :page

  resources :mailings do
    resources :submissions
  end

  namespace :orga do
    resources :seasons
  end

  # get 'activities(.:format)', to: 'activities#index', as: :activities
  get 'activities(/page/:page)(.:format)', to: 'activities#index', as: :activities
end
