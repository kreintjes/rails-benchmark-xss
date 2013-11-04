class ApplicationController < ActionController::Base
  include BeforeRender

  protect_from_forgery with: :exception # Disabled as a precaution (it could hinder the dynamic scanners)
  respond_to :html

  rescue_from StandardError, :with => :handle_exception # Safe rescue possible exceptions if needed (to prevent false positives)

  before_filter :parse_method

  BENCHMARK_MODULES = ['base', 'url_helper']
  RUN_MODE = nil # Let the system decide based on the environment

  #before_render { @result = @result.html_safe if @result.present? } # Make sure all results are marked as html safe just before render

  def running?
    return RUN_MODE if RUN_MODE.present?
    Rails.env.production?
  end
  helper_method :running?

  def active_modules
    if ENV['BENCHMARK_MODULES'].present?
      ENV['BENCHMARK_MODULES'].split(',')
    else
      BENCHMARK_MODULES
    end
  end
  helper_method :active_modules

  # In URLs we replace ? in the method with a -, so the scanners will not mess with it (because they think it is part of the GET query string).
  def parse_method
    params[:method].gsub!('-', '?') if params[:method].present?
  end

  # In URLs we replace ? in the method with a -, so the scanners will not mess with it (because they think it is part of the GET query string).
  def encode_method(method)
    method.gsub('?', '-')
  end
  helper_method :encode_method

  # This method is called upon any exception. It prevents false positives caused by exceptions that have nothing to do with an SQL injection.
  # It checks if the exception has nothing to do with an SQL injection, but could possibly cause the scanners to see it as a false positive.
  # If so, the exception is logged and a standard response is shown by (empty) rendering the normal controller action, so the scanners will believe all is well.
  def handle_exception(exception)
    if safe_rescue_exception?(exception)
      # This exception should be safely rescued to prevent false positive for the dynamic scanners. Log the exception
      message = "Automatic handled " + exception.class.to_s + ": " + exception.message + " to prevent false positive"
      logger.debug message
      flash[:alert] = message unless running?
      # Try to render the normal controller action (although with empty results) as if everything is well
      render
    else
      # This exception should not be safe rescued (possible SQL injection!). Simply raise the exception again to display the full error.
      raise exception
    end
  end

  # Do we need to safe rescue this exception?
  def safe_rescue_exception?(exception)
    # Exceptions to be safe rescued
    errors = [

    ]
    errors.each do |error|
      if exception.is_a?(error[:type])
        match = true
        error[:messages].each do |message|
          unless exception.message.scan(message).present?
            match = false
            break
          end
        end
        return true if match
      end
    end
    false
  end

  # Show 404
  def show_404
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end
end
