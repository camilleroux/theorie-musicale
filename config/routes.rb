Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :keys, :only => [:show], :path => "tonalite" do
    resources :chord_qualities, :only => [:index, :show], :path => "qualite"
    resources :chords, :only => [:index, :show], :path => "accords" do
      get :staff, :on => :member
    end

    resources :intervals, :only => [:show], :path => "intervalles"

    resources :scales, :only => [:index, :show], :path => "gammes" do
      resources :modes, :only => [:index, :show], :path => "modes"
    end
  end

  resources :scales, :only => [:index, :show], :path => "gammes" do
    get :staff, :on => :member
    resources :modes, :only => [:index, :show] do
      get :staff, :on => :member
    end
  end

  resources :chords, :only => [:index, :show], :path => "accords" do
    get :staff, :on => :member
  end

  resources :intervals, :only => [:index, :show], :path => "intervalles" do
    get :staff, :on => :member
  end

  resources :notes, :only => [:index, :show] do
    get :staff, :on => :member
  end

end
