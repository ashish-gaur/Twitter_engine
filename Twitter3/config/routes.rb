Twitter3::Engine.routes.draw do
	resources :sessions

	root :to => "sessions#login"

	match 'create',:to => "users#create"
	match 'signup', :to => "users#new"
	match 'login_signup', :to => "sessions#login"
	match 'login', :to => "sessions#login_attempt"
	match 'logout', :to => "sessions#logout"
	match 'home', :to => "sessions#home"
	match 'profile', :to => 'sessions#profile'
	match 'setting', :to => "sessions#setting"
	match 'tweet', :to => "sessions#add_tweet"
	match 'edit', :to => 'sessions#edit'
	match 'update', :to => 'sessions#update'
	match 'follow', :to => 'sessions#follow'
	match 'unfollow', :to => 'sessions#unfollow'
	match 'network', :to => 'sessions#network'
	match 'search_user', :to => 'sessions#search_user'
	match 'activation_error', :to => 'sessions#error'
	match 'error', :to => 'sessions#error'
	match 'confirm', :to => 'sessions#confirm'
	match 'confirm_user', :to => 'sessions#confirm_user'
	match 'accept_request', :to => "sessions#accept_request"
	match 'deny_request', :to => "sessions#deny_request"
	match 'accept', :to => "sessions#accept"
	match 'deny', :to => "sessions#deny"
	match 'cancel', :to => "sessions#cancel"
	match 'search', :to => "sessions#search"
	match 'time', :to => 'sessions#convert_time_to_string'
end
