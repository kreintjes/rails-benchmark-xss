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
  match "base_test/javascript_helper_form/:method(/:option)", :controller => 'base_test', :action => 'javascript_helper_form', :via => 'get', :as => 'base_test_javascript_helper_form'
  match "base_test/javascript_helper_perform/:method(/:option)", :controller => 'base_test', :action => 'javascript_helper_perform', :via => 'post', :as => 'base_test_javascript_helper_perform'
  match "base_test/erb_util_form/:method(/:option)", :controller => 'base_test', :action => 'erb_util_form', :via => 'get', :as => 'base_test_erb_util_form'
  match "base_test/erb_util_perform/:method(/:option)", :controller => 'base_test', :action => 'erb_util_perform', :via => 'post', :as => 'base_test_erb_util_perform'

  # Normal helper tests
  match "normal_helpers_test/number_helper_form/:method(/:option)", :controller => 'normal_helpers_test', :action => 'number_helper_form', :via => 'get', :as => 'normal_helpers_test_number_helper_form'
  match "normal_helpers_test/number_helper_perform/:method(/:option)", :controller => 'normal_helpers_test', :action => 'number_helper_perform', :via => 'post', :as => 'normal_helpers_test_number_helper_perform'
  match "normal_helpers_test/tag_helper_form/:method(/:option)", :controller => 'normal_helpers_test', :action => 'tag_helper_form', :via => 'get', :as => 'normal_helpers_test_tag_helper_form'
  match "normal_helpers_test/tag_helper_perform/:method(/:option)", :controller => 'normal_helpers_test', :action => 'tag_helper_perform', :via => 'post', :as => 'normal_helpers_test_tag_helper_perform'
  match "normal_helpers_test/text_helper_form/:method(/:option)", :controller => 'normal_helpers_test', :action => 'text_helper_form', :via => 'get', :as => 'normal_helpers_test_text_helper_form'
  match "normal_helpers_test/text_helper_perform/:method(/:option)", :controller => 'normal_helpers_test', :action => 'text_helper_perform', :via => 'post', :as => 'normal_helpers_test_text_helper_perform'
  match "normal_helpers_test/translation_helper_form/:method(/:option)", :controller => 'normal_helpers_test', :action => 'translation_helper_form', :via => 'get', :as => 'normal_helpers_test_translation_helper_form'
  match "normal_helpers_test/translation_helper_perform/:method(/:option)", :controller => 'normal_helpers_test', :action => 'translation_helper_perform', :via => 'post', :as => 'normal_helpers_test_translation_helper_perform'
  match "normal_helpers_test/url_helper_form/:method(/:option)", :controller => 'normal_helpers_test', :action => 'url_helper_form', :via => 'get', :as => 'normal_helpers_test_url_helper_form'
  match "normal_helpers_test/url_helper_perform/:method(/:option)", :controller => 'normal_helpers_test', :action => 'url_helper_perform', :via => 'post', :as => 'normal_helpers_test_url_helper_perform'

  # Catch all to disable logging of routing errors
  match '*path', :via => [:get, :post], :controller => 'application', :action => 'show_404'
end
