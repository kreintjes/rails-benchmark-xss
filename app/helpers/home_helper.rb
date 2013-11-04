module HomeHelper
  def render_module_tests(key, name = nil, &block)
    name = key.humanize if name.nil?
    if active_modules.include?(key)
      content_tag(:h3, "#{name} tests enabled").safe_concat(capture(&block)).safe_concat(content_tag(:p, "Disable by removing '#{key}' from BENCHMARK_MODULES"))
    else
      content_tag(:h3, "#{name} tests disabled").safe_concat(content_tag(:p, "Enable by adding '#{key}' to BENCHMARK_MODULES"))
    end
  end
end