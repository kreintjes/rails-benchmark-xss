Sqli::Application.routes.draw do
  get "home/index"
  root :to => 'home#index'

  # Base tests
  match "base_test/automatic_protection_form/:method(/:option)", :controller => 'base_test', :action => 'automatic_protection_form', :via => 'get', :as => 'base_test_automatic_protection_form'
  match "base_test/automatic_protection_perform/:method(/:option)", :controller => 'base_test', :action => 'automatic_protection_perform', :via => 'post', :as => 'base_test_automatic_protection_perform'
  match "base_test/sanitize_helper_form/:method(/:option)", :controller => 'base_test', :action => 'sanitize_helper_form', :via => 'get', :as => 'base_test_sanitize_helper_form'
  match "base_test/sanitize_helper_perform/:method(/:option)", :controller => 'base_test', :action => 'sanitize_helper_perform', :via => 'post', :as => 'base_test_sanitize_helper_perform'
  match "base_test/tag_helper_form/:method(/:option)", :controller => 'base_test', :action => 'tag_helper_form', :via => 'get', :as => 'base_test_tag_helper_form'
  match "base_test/tag_helper_perform/:method(/:option)", :controller => 'base_test', :action => 'tag_helper_perform', :via => 'post', :as => 'base_test_tag_helper_perform'
  match "base_test/erb_util_form/:method(/:option)", :controller => 'base_test', :action => 'erb_util_form', :via => 'get', :as => 'base_test_erb_util_form'
  match "base_test/erb_util_perform/:method(/:option)", :controller => 'base_test', :action => 'erb_util_perform', :via => 'post', :as => 'base_test_erb_util_perform'

  # Catch all to disable logging of routing errors
  match '*path', :via => [:get, :post], :controller => 'application', :action => 'show_404'
end
