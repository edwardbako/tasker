class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &block)
    str = "#{text ? text : object.class.human_attribute_name(method.to_s)} #{object.errors[method].join(', ')}"
    super(method, str, options.merge({class: ' control-label'}){|k, n, o| n + o}, &block)
  end

  def error_label(method, *args)
    if object.errors[method].any?
      label method, *args
    else
      '<br>'.html_safe if object.errors.any?
    end
  end

  [:text_field, :text_area, :email_field, :phone_field, :date_field, :password_field, :number_field].each do |meth|
    define_method meth do |method, options = {}|
      super(method, merged_options(options))
    end
  end

  def check_box(method, options = {})
    super(method, options.merge({class: ' form-check-input'}){|k, n, o| n + o}) + ' ' + label(method, class: 'form-check-label')
  end

  def merged_options(options)
    options.merge({class: ' form-control'}){|k, n, o| n + o}
  end
end