class BaseTestController < ApplicationController
  TAG_OPTIONS = ['div', 'p', 'strong', 'input', 'br']
  ATTRIBUTE_KEY_OPTIONS = ['class', 'style', 'disabled', 'scoped']
  DATA_ATTRIBUTE_KEY_OPTIONS = ['test-key-1', 'test-key-2']

  def automatic_protection_form
  end

  def automatic_protection_perform
    case params[:method]
    when 'disabled'
      @result = params[:input].html_safe
    when 'standard'
      @result = params[:input]
    else
      raise "Unknown method '#{params[:method]}'"
    end
  end

  def sanitize_helper_form
  end

  def sanitize_helper_perform
    # Determine result
    case params[:method]
    when 'sanitize'
      case params[:option]
      when 'none'
        options = { :tags => [], :attributes => [] }
      when 'no_tags'
        options = { :tags => [] }
      when 'no_attributes'
        options = { :attributes => [] }
      when 'custom'
        options = { :tags => %w(table tr td b i u strong em p div span ul li), :attributes => %w(id class title) }
      when 'default'
        options = {}
      end
      @result = ActionController::Base.helpers.send(params[:method], params[:input], options)
    when 'strip_tags', 'sanitize_css'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
    else
      raise "Unknown method '#{params[:method]}'"
    end

    # Determine partial
    case params[:method]
    when 'sanitize_css'
      @partial = 'sanitize_css_result'
    else
      @partial = 'shared/simple_result'
    end
  end

  def tag_helper_form
    # Determine partial
    case params[:method]
    when 'content_tag'
      @partial = 'content_tag_fields'
    when 'tag'
      @partial = 'tag_fields'
    else
      @partial = 'simple_input'
    end
  end

  def tag_helper_perform
    case params[:method]
    when 'content_tag'
      check_tag_allowed()
      case params[:option]
      when 'param'
        @result = ActionController::Base.helpers.send(params[:method], params[:tag], params[:content], options_for_tag_helper())
      when 'block'
        @result = ActionController::Base.helpers.send(params[:method], params[:tag], options_for_tag_helper()) { "Block + content: " + params[:content] }
      end
    when 'tag'
      check_tag_allowed()
      @result = ActionController::Base.helpers.send(params[:method], params[:tag], options_for_tag_helper(), params[:option] == 'open_true')
    when 'escape_once'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
    else
      raise "Unknown method '#{params[:method]}'"
    end
  end

  def javascript_helper_form
  end

  def javascript_helper_perform
    case params[:method]
    when 'escape_javascript'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
    else
      raise "Unknown method '#{params[:method]}'"
    end
  end

  def erb_util_form
  end

  def erb_util_perform
    # Determine result
    case params[:method]
    when 'html_escape', 'html_escape_once'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
    when 'json_escape'
      @result = ActionController::Base.helpers.send(params[:method], params[:input].to_json)
    else
      raise "Unknown method '#{params[:method]}'"
    end

    # Determine partial
    case params[:method]
    when 'json_escape'
      @partial = 'json_escape_result'
    else
      @partial = 'shared/simple_result'
    end
  end

private
  def check_tag_allowed
    # The entered tag is of course not escaped, and should thus be checked
    redirect_to :root, :alert => 'Tag not allowed' unless TAG_OPTIONS.include?(params[:tag])
  end

  def options_for_tag_helper
    options = {}
    options.merge!({ params[:attribute_key] => params[:attribute_value] }) if params[:attribute_key].present? && ATTRIBUTE_KEY_OPTIONS.include?(params[:attribute_key]) # Check if key is allowed, since it is not escaped
    options.merge!({ :data => { params[:data_attribute_key] => params[:data_attribute_value] } }) if params[:data_attribute_key].present? && DATA_ATTRIBUTE_KEY_OPTIONS.include?(params[:data_attribute_key]) # Check if key is allowed, since it is not escaped
    options
  end
end
