Rails.application.routes.draw do
  root to: 'home#index'

  get 'top_urls', to: 'reports#top_urls'
  get 'top_referrers', to: 'reports#top_referrers'
end
