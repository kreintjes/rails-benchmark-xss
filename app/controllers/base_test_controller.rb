class BaseTestController < ApplicationController
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
  end

  def tag_helper_perform
    case params[:method]
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
end
