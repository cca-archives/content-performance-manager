Rails.application.routes.draw do
  resources :metrics
  root to: 'content/items#index'

  namespace :content do
    resources :items, only: %w(index show), param: :content_id
  end

  resources :content_items, only: %w(index show), param: :content_id do
    scope module: "audits" do
      get :audit, to: "audits#show"
      post :audit, to: "audits#save"
      patch :audit, to: "audits#save"
    end
  end

  get "content/stats", to: "content_metrics#stats"
  get "content/show", to: "content_metrics#show"

  resources :content_metrics, only: %w(index)

  namespace :audits do
    get '/', to: "audits#index"
    resource :report, only: :show
    resource :guidance, only: :show

    post :allocations, to: "allocations#destroy", constraints: ->(req) { req.parameters["allocate_to"] == "no_one" }
    resources :allocations, only: %w(index create)
  end

  resources :taxonomy_projects, path: '/taxonomy-projects', only: %w(index show new create) do
    get 'next', on: :member
  end

  resources :taxonomy_todos, only: %w(show update) do
    post 'dont_know', on: :member
    post 'not_relevant', on: :member
  end

  if Rails.env.development?
    mount GovukAdminTemplate::Engine, at: "/style-guide"
  end

  class ProxyAccessContraint
    def matches?(request)
      !request.env['warden'].try(:user).nil?
    end
  end

  mount Proxies::IframeAllowingProxy.new => Proxies::IframeAllowingProxy::PROXY_BASE_PATH, constraints: ProxyAccessContraint.new
end
