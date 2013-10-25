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
    case params[:method]
    when 'sanitize'
      case params[:option]
      when 'disabled'
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
    else
      raise "Unknown method '#{params[:method]}'"
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

  def erb_util_form
  end

  def erb_util_perform
    case params[:method]
    when 'h', 'html_escape', 'html_escape_once'
      @result = ActionController::Base.helpers.send(params[:method], params[:input])
    else
      raise "Unknown method '#{params[:method]}'"
    end
  end
end
