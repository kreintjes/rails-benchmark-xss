class TranslationHelperTestController < ApplicationController
  def helpers_form
  end

  def helpers_perform
    case params[:method]
    when 'translate'
      if params[:option] =~ /missing_key_with_default_/
        default = params[:option] == 'missing_key_with_default_data' ? params[:data] : key_name(params[:option])
        @result = ActionController::Base.helpers.send(params[:method], :missing_key, :default => default, :data => params[:data], :count => params[:count].to_i)
      else
        @result = ActionController::Base.helpers.send(params[:method], key_name(params[:option]), :data => params[:data], :count => params[:count].to_i)
      end
    end
  end

private
  def key_name(option)
    case option
    when 'key3html'
      :'key3.html'
    when /missing_key_with_default_/
      key_name(option.gsub('missing_key_with_default_', ''))
    else
      option.to_sym
    end
  end
end
