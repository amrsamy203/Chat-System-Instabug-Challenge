Rails.application.routes.draw do
  # Applying Nested Routes
  resources :applications_system, except: [:new, :edit, :destroy], path: '/applications' , param: :identifier_token do
    resources :chats, except: [:new, :edit, :destroy, :update], path: '/chats', param: :identifier_number do
      resources :messages, except: [:new, :edit, :destroy], path: '/messages', param: :identifier_number do
        collection do
          get :search
        end
      end
    end
  end
end