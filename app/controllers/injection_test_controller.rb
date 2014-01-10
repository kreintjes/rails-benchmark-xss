class InjectionTestController < ApplicationController
  def injection_form
    render 'shared/simple_form'
  end

  def injection_perform
    case params[:method]
    when 'automatic_protection_disabled'
      @result = params[:input].html_safe
    else
      raise "Unknown method '#{params[:method]}'"
    end
    @partial = 'simple_result'
    render 'shared/simple_perform'
  end
end
