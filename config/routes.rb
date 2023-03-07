Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    namespace :web, defaults: {format: :json} do
      namespace :v1 do
        resources :commons, only: [] do
          collection do
            get :logistics_info
            post :inquiries
            post :leave_words
            get :products
            get :product_classify
            get :product_detail
            get :banners
            get :introductions
            get :search_products
          end
        end
      end
    end

    namespace :admin, defaults: {format: :json} do
      namespace :v1 do
        resources :commons, only: [] do
          collection do
            get :routes
            post :upload_attachment
            get :product_classify
          end
        end

        resources :searchs, only: [] do
          collection do
            get :products
            get :customers
          end
        end
        
        namespace :front_end do
          resources :banners, only: [:index, :create, :update, :destroy]
          resources :logistics_infos, only: [:index, :create, :update, :destroy]
          resources :introductions, only: [:index, :create, :update, :destroy] do
            collection do
              get :company_introduction
              put :update_company_introduction
            end
          end
        end

        namespace :crm do
          resources :leave_words, only: [:index]
          resources :customers, only: [:index, :create, :update, :destroy] do
            member do
              # 地址信息接口
              get :addresses
              post :new_address
              put :update_address
              delete :delete_address
              # 收票地址信息接口
              get :invoices
              post :new_invoice
              put :update_invoice
              delete :delete_invoice
              put :distribute_employee
            end
          end
        end

        namespace :product do
          resources :products, only: [:index, :create, :update, :destroy] do
            member do
              get :quotation_histories
            end
            collection do
              get :classify
              put :update_classify
              post :import
            end
          end
          resources :advantage_products, only: [:index, :create, :update, :destroy]
        end    

        namespace :inquiry do
          resources :inquiries, only: [:index, :create, :update, :show] do
            collection do
              get :exchange_rate
              put :update_exchange_rate
              get :testing_fee
              put :update_testing_fee
              get :appraisal_fee
              put :update_appraisal_fee
              put :send_quotation
            end
            member do
              # get :quotation_details
              put :update_quotation
              put :distribute_employee
              put :relate_customer
            end
          end
          resources :inquiry_quotations, only: [:index, :show] do
            collection do
              post :create_customer_order
            end
            member do
              get :quotation_details
              post :new_quotation
              put :update_quotation
              get :quotation_histories
            end
          end
        end

        namespace :customer_order do
          resources :customer_orders, only: [:index] do
            member do
              put :received_amount
            end
          end
        end

        namespace :hr do
          resources :employees, only: [:index, :create, :update] do
            collection do
              post :sign_in
              post :sign_out
            end
            member do
              get :role
              put :update_role
            end
          end

          resources :roles, only: [:index, :create, :update] do
            member do
              get :permission
              put :update_permission
              get :employee
            end
          end
        end

      end
    end

  end
end