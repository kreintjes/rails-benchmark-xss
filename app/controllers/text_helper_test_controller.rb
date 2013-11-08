class TextHelperTestController < ApplicationController
  def helpers_form
    @partial = params[:method] + '_fields'
  end

  def helpers_perform
    case params[:method]
    when 'highlight'
      @result = ActionController::Base.helpers.send(params[:method], params[:text], params[:phrases])
    when 'simple_format'
      check_tag_allowed(:content_tag, :options_wrapper)
      options = {}
      options = { :wrapper_tag => params[:options_wrapper_tag] } if params[:options_wrapper_tag].present?
      @result = ActionController::Base.helpers.send(params[:method], params[:text], set_html_options(), options)
    when 'truncate'
      options = (params[:omission].present? ? { :omission => params[:omission] } : {})
      if(params[:block_content]).present?
        @result = ActionController::Base.helpers.send(params[:method], params[:text], options) { params[:block_content] }
      else
        @result = ActionController::Base.helpers.send(params[:method], params[:text], options)
      end
    end
  end
end
