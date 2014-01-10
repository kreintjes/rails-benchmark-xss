class NormalHelpersTestController < ApplicationController
  def number_helper_form
    @option_fields = options_with_defaults_for_method(params[:method], params[:option])
    @partial = 'number_helper_fields'
    render 'shared/simple_form'
  end

  def number_helper_perform
    case params[:method]
    when 'number_to_currency', 'number_to_human', 'number_to_human_size', 'number_to_percentage', 'number_to_phone', 'number_with_delimiter', 'number_with_precision'
      @result = ActionController::Base.helpers.send(params[:method], params[:number], build_options_for_method(params[:method], params[:option], params))
    else
      raise "Unknown method '#{params[:method]}'"
    end
    render 'shared/simple_perform'
  end

  def tag_helper_form
    # Determine partial
    if params[:method] == 'cdata_section'
      # Use simple input
    else
      @method_partial = params[:method] + '_fields'
    end
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
    when 'cdata_section'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
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
      @result = ActionController::Base.helpers.send(params[:method], params[:text], set_html_options())
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
    @partial = 'translation_helper_fields'
    render 'shared/simple_form'
  end

  def translation_helper_perform
    case params[:method]
    when 'translate'
      case params[:default]
      when 'no_default'
        default = nil
      when 'key1', 'key2', 'key3', 'missing_key'
        default = translation_key_name(params[:default])
      when 'data'
        default = params[:data]
      else
        default = params[:default]
      end
      @result = ActionController::Base.helpers.send(params[:method], translation_key_name(params[:key]), :default => default, :data => params[:data], :count => params[:count].to_i)
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
  def options_with_defaults_for_method(method, option)
    case method
    when 'number_to_currency'
      { locale: I18n.locale, precision: 2, unit: '$', separator: '.', delimiter: ',', format: '%u%n', negative_format: '-%u%n', raise: false }
    when 'number_to_human'
      { locale: I18n.locale, precision: 3, significant: true, separator: '.', delimiter: '', strip_insignificant_zeros: true, units: unit_options_with_defaults_for_option(option), format: '%n %u', raise: false }
    when 'number_to_human_size'
      { locale: I18n.locale, precision: 3, significant: true, separator: '.', delimiter: '', strip_insignificant_zeros: true, prefix: [:binary, :si], raise: false }
    when 'number_to_percentage'
      { locale: I18n.locale, precision: 3, significant: false, separator: '.', delimiter: '', strip_insignificant_zeros: false, format: '%n%', raise: false }
    when 'number_to_phone'
      { area_code: false, delimiter: '-', extension: nil, country_code: nil, raise: false }
    when 'number_with_delimiter'
      { locale: I18n.locale, separator: '.', delimiter: ',', raise: false }
    when 'number_with_precision'
      { locale: I18n.locale, precision: 3, sigfnificant: false, separator: '.', delimiter: ',', strip_insignificant_zeros: false, raise: false }
    else
      {}
    end
  end

  def unit_options_with_defaults_for_option(option)
    case option
    when 'units_as_hash'
      units = { femto: nil, pico: nil, nano: nil, micro: nil, mili: nil, centi: nil, deci: nil, unit: nil, ten: nil, hundred: nil, thousand: nil, million: nil, billion: nil, trillion: nil, quadrillion: nil }
    else
      units = nil
    end
  end

  def build_options_for_method(method, option, params)
    options = {}
    options_with_defaults_for_method(method, option).each do |option, default|
      if default.is_a?(Hash)
        value = params[option].to_hash.symbolize_keys!.delete_if { |k,v| v.blank? }
      elsif default.is_a?(TrueClass) || default.is_a?(FalseClass)
        value = params[option].present? # Boolean option
      elsif default.is_a?(Array)
        value = default.find(Proc.new { params[option] }) { |d| d.to_s == params[option] } if params[option].present? # Array option: get first matching element from default or otherwise return param value
      elsif default.is_a?(Integer)
        value = params[option].to_i if params[option].present? # Integer option
      else
        value = params[option] if params[option].present? # Text option
      end
      options[option] = value
    end
    options
  end

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

  def translation_key_name(key)
    case key
    when 'key1'
      :key1
    when 'key2'
      :key2_html
    when 'key3'
      :'key3.html'
    when 'data'
      params[:data]
    else
      key
    end
  end
end
