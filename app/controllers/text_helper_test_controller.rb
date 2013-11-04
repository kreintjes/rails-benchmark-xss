class TextHelperTestController < ApplicationController
  def helpers_form
    @partial = params[:method] + '_fields'
  end

  def helpers_perform
    case params[:method]
    when 'highlight'
      @result = ActionController::Base.helpers.send(params[:method], params[:text], params[:phrases])
    when 'simple_format'
      html_options = (params[:html_options_style].present? ? { :style => params[:html_options_style] } : {})
      @result = ActionController::Base.helpers.send(params[:method], params[:text], html_options)
    when 'truncate'
      options = (params[:omission].present? ? { :omission => params[:omission] } : {})
      if(params[:block_content]).present?
        @result = ActionController::Base.helpers.send(params[:method], params[:text], options) { params[:block_content] }
      else
        @result = ActionController::Base.helpers.send(params[:method], params[:text], options)
      end
    end
  end

  def options(type = 'link_to')
    options = {}
      if ['button_to', 'link_to'].include?(type)
      data_options = {}
      data_options.merge!({ :confirm => params[:data_confirm] }) if params[:data_confirm].present?
      data_options.merge!({ :disable_with => params[:data_disable_with] }) if params[:data_disable_with].present?
      options.merge!({ :data => data_options }) if data_options.present?
    end
    if type == 'button_to'
      form_options = {}
      form_options.merge!({ :style => params[:form_style] }) if params[:form_style].present?
      options.merge!({ :form => form_options }) if form_options.present?
      options.merge!({ :form_class => params[:form_class] }) if params[:form_class].present?
      options.merge!({ :method => :get }) # Needed To disable CSRF protection, since it does not work for Abstract Controller
    end
    if type == 'mail_to'
      ['cc', 'bcc', 'subject', 'body'].each do |option|
        options.merge!({ option => params[option] }) if params[option].present?
      end
    end
    options
  end
end
