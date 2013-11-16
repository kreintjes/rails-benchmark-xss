class NormalHelpersTestController < ApplicationController
   def tag_helper_form
    # Determine partial
    @method_partial = params[:method] + '_fields'
    render 'shared/simple_form'
  end

  def tag_helper_perform
    case params[:method]
    when 'content_tag'
      check_tag_allowed(:content_tag)
      case params[:option]
      when 'param'
        @result = ActionController::Base.helpers.send(params[:method], params[:html_tag], params[:content], set_html_options())
      when 'block'
        @result = ActionController::Base.helpers.send(params[:method], params[:html_tag], set_html_options()) { "Block + content: " + params[:content] }
      end
    when 'tag'
      check_tag_allowed(:empty_tag)
      @result = ActionController::Base.helpers.send(params[:method], params[:html_tag], set_html_options(), params[:option] == 'open_true')
    else
      raise "Unknown method '#{params[:method]}'"
    end
    render 'shared/simple_perform'
  end

  def text_helper_form
    @method_partial = params[:method] + '_fields'
    @partial = 'text_helper_fields'
    render 'shared/simple_form'
  end

  def text_helper_perform
    case params[:method]
    when 'highlight'
      @result = ActionController::Base.helpers.send(params[:method], params[:text], params[:phrases])
    when 'simple_format'
      check_tag_allowed(:content_tag, :options_wrapper)
      options = (params[:options_wrapper_tag].present? ? { :wrapper_tag => params[:options_wrapper_tag] } : {})
      @result = ActionController::Base.helpers.send(params[:method], params[:text], set_html_options(), options)
    when 'truncate'
      options = (params[:omission].present? ? { :omission => params[:omission] } : {})
      if(params[:block_content]).present?
        @result = ActionController::Base.helpers.send(params[:method], params[:text], options) { params[:block_content] }
      else
        @result = ActionController::Base.helpers.send(params[:method], params[:text], options)
      end
    end
    render 'shared/simple_perform'
  end

  def translation_helper_form
    @partial = 'translation_fields'
    render 'shared/simple_form'
  end

  def translation_helper_perform
    case params[:method]
    when 'translate'
      if params[:option] =~ /missing_key_with_default_/
        default = params[:option] == 'missing_key_with_default_data' ? params[:data] : translation_key_name(params[:option])
        @result = ActionController::Base.helpers.send(params[:method], :missing_key, :default => default, :data => params[:data], :count => params[:count].to_i)
      else
        @result = ActionController::Base.helpers.send(params[:method], translation_key_name(params[:option]), :data => params[:data], :count => params[:count].to_i)
      end
    end
    render 'shared/simple_perform'
  end

  def url_helper_form
    case params[:method]
    when 'link_to', 'link_to_unless', 'link_to_if', 'link_to_unless_current'
      @method_partial = 'link_to_fields'
    else
      @method_partial = params[:method] + '_fields'
    end
    render 'shared/simple_form'
  end

  def url_helper_perform
    case params[:method]
    when 'button_to', 'link_to'
      case params[:option]
      when 'param'
        @result = ActionController::Base.helpers.send(params[:method], params[:name].presence, params[:url], url_helper_options(params[:method]))
      when 'block'
        @result = ActionController::Base.helpers.send(params[:method], params[:url], url_helper_options(params[:method])) { "Block + name: " + params[:name] }
      end
    when 'link_to_unless', 'link_to_if'
      case params[:option]
      when 'true'
        @result = ActionController::Base.helpers.send(params[:method], true, "true name in param: " + params[:name], params[:url], url_helper_options()) { "true name in block: " + params[:name] }
      when 'false'
        @result = ActionController::Base.helpers.send(params[:method], false, "false name in param: " + params[:name], params[:url], url_helper_options()) { "false name in block: " + params[:name] }
      end
    when 'mail_to'
      case params[:option]
      when 'param'
        @result = ActionController::Base.helpers.send(params[:method], params[:email_address], params[:name].presence, url_helper_options('mail_to'))
      when 'block'
        @result = ActionController::Base.helpers.send(params[:method], params[:email_address], url_helper_options('mail_to')) { "Block + name: " + params[:name] }
      end
    end
    render 'shared/simple_perform'
  end

private
  def url_helper_options(type = 'link_to')
    options = {}
    data_options = {}
    data_options.merge!({ :confirm => params[:data_confirm] }) if params[:data_confirm].present?
    data_options.merge!({ :disable_with => params[:data_disable_with] }) if params[:data_disable_with].present?
    options.merge!({ :data => data_options }) if data_options.present?
    if type == 'button_to'
      options = set_html_options(options, :form, :form)
      options.merge!({ :form_class => params[:form_class] }) if params[:form_class].present?
      options.merge!({ :method => :get }) # Needed to disable CSRF protection, since it does not work for Abstract Controller
    end
    if type == 'mail_to'
      ['cc', 'bcc', 'subject', 'body'].each do |option|
        options.merge!({ option => params[option] }) if params[option].present?
      end
    end
    set_html_options(options, :link)
  end

  def translation_key_name(option)
    case option
    when 'key3html'
      :'key3.html'
    when /missing_key_with_default_/
      translation_key_name(option.gsub('missing_key_with_default_', ''))
    else
      option.to_sym
    end
  end
end
