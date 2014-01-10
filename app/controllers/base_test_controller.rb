class BaseTestController < ApplicationController
  def automatic_protection_form
    render 'shared/simple_form'
  end

  def automatic_protection_perform
    case params[:method]
    when 'standard'
      @result = params[:input]
    else
      raise "Unknown method '#{params[:method]}'"
    end
    @partial = 'simple_result'
    render 'shared/simple_perform'
  end

  def sanitize_helper_form
    render 'shared/simple_form'
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
    when 'strip_tags'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
      @result = @result.html_safe if params[:option] == 'html_safe'
    when 'sanitize_css'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
    else
      raise "Unknown method '#{params[:method]}'"
    end

    # Determine partial
    case params[:method]
    when 'sanitize_css'
      @partial = 'sanitize_css_result'
    else
      @partial = 'shared/simple_result' # Use the shared simple result, since these base sanitize helpers are meant for the HTML body context only
    end
    render 'shared/simple_perform'
  end

  def tag_helper_form
    render 'shared/simple_form'
  end

  def tag_helper_perform
    case params[:method]
    when 'escape_once'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
    else
      raise "Unknown method '#{params[:method]}'"
    end
    @partial = 'simple_result'
    render 'shared/simple_perform'
  end

  def javascript_helper_form
    render 'shared/simple_form'
  end

  def javascript_helper_perform
    case params[:method]
    when 'escape_javascript'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
      @result = @result.html_safe if params[:option] == 'html_safe'
    else
      raise "Unknown method '#{params[:method]}'"
    end
    @partial = 'javascript_helper_result'
    render 'shared/simple_perform'
  end

  def erb_util_form
    render 'shared/simple_form'
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
      @partial = 'simple_result'
    end
    render 'shared/simple_perform'
  end
end
