class UrlHelperTestController < ApplicationController
  def helpers_form
    case params[:method]
    when 'link_to', 'link_to_unless', 'link_to_if', 'link_to_unless_current'
      @partial = 'link_to_fields'
    else
      @partial = params[:method] + '_fields'
    end
  end

  def helpers_perform
    case params[:method]
    when 'button_to', 'link_to'
      case params[:option]
      when 'param'
        @result = ActionController::Base.helpers.send(params[:method], params[:name].presence, params[:url], options(params[:method]))
      when 'block'
        @result = ActionController::Base.helpers.send(params[:method], params[:url], options(params[:method])) { "Block + name: " + params[:name] }
      end
    when 'link_to_unless', 'link_to_if'
      case params[:option]
      when 'true'
        @result = ActionController::Base.helpers.send(params[:method], true, "true name in param: " + params[:name], params[:url], options()) { "true name in block: " + params[:name] }
      when 'false'
        @result = ActionController::Base.helpers.send(params[:method], false, "false name in param: " + params[:name], params[:url], options()) { "false name in block: " + params[:name] }
      end
    when 'mail_to'
      case params[:option]
      when 'param'
        @result = ActionController::Base.helpers.send(params[:method], params[:email_address], params[:name].presence, options('mail_to'))
      when 'block'
        @result = ActionController::Base.helpers.send(params[:method], params[:email_address], options('mail_to')) { "Block + name: " + params[:name] }
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
      options.merge!({ :method => :get }) # To disable CSRF protection, since it does not work for Abstract Controller
    end
    if type == 'mail_to'
      ['cc', 'bcc', 'subject', 'body'].each do |option|
        options.merge!({ option => params[option] }) if params[option].present?
      end
    end
    options
  end
end
