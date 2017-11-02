Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/total(/:page)' => 'posts#total'
  get 'posts/best(/:page)' => 'posts#best'
  get 'posts/search(/:page)' => 'posts#search'
  post 'posts/search(/:page)' => 'posts#search'
  post 'posts/readmoreposts/:p_id' => 'posts#readmoreposts'
  post 'posts/readmorecommentone/:c_id' => 'posts#readmorecommentone'
  post 'posts/readmorecommenttwo/:c_id' => 'posts#readmorecommenttwo'
  root 'posts#total'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
