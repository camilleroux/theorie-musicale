Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'welcome#index'

  resources :keys, only: [:show], path: 'tonalite' do
    resources :chord_qualities, only: [:index, :show], path: 'qualite'
    resources :chords, only: [:index, :show], path: 'accords' do
      get 'guitare-:position', action: :guitar, on: :member, as: :guitar, format: true, constraints: {position: /[1-3]/, format: 'svg'}
      get 'piano', action: :piano, on: :member, as: :piano, format: true, constraints: {format: 'svg'}
    end

    resources :intervals, only: [:show], path: 'intervalles' do
      get 'piano', action: :piano, on: :member, as: :piano, format: true, constraints: {format: 'svg'}
    end

    resources :scales, only: [:index, :show], path: 'gammes' do
      resources :modes, only: [:index, :show], path: 'modes' do
        get 'piano', action: :piano, on: :member, as: :piano, format: true, constraints: {format: 'svg'}
      end
    end
  end

  resources :scales, only: [:index, :show], path: 'gammes' do
    resources :modes, only: [:index, :show] do
      get 'piano', action: :piano, on: :member, as: :piano, format: true, constraints: {format: 'svg'}
    end
  end

  resources :chords, only: [:index, :show], path: 'accords' do
    get 'guitare-:position', action: :guitar, on: :member, as: :guitar, format: true, constraints: {position: /[1-3]/, format: 'svg'}
    get 'piano', action: :piano, on: :member, as: :piano, format: true, constraints: {format: 'svg'}
  end

  resources :intervals, only: [:index, :show], path: 'intervalles' do
    get 'piano', action: :piano, on: :member, as: :piano, format: true, constraints: {format: 'svg'}
  end

  resources :progressions, only: [:index, :show]

  resources :notes, only: [:index, :show] do
    get 'piano', action: :piano, on: :member, as: :piano, format: true, constraints: {format: 'svg'}
  end
end
