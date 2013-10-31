class Apirizer::ControllerResource < CanCan::ControllerResource

  def initialize(controller, *args)
    super
    controller.instance_variable_set :@_cancan_resource, self
  end

  def build_resource
    # https://github.com/inossidabile/protector/issues/31
    resource = resource_base.new(resource_params || {}).restrict!(resource_base.protector_subject)
    assign_attributes(resource)
  end

  def resource_params
    if strong_parameters?
      @controller.permitted_params
    else
      # maybe you're using 'resource' or even 'pony' key, not 'api_v1_resource'
      super || resource_params_by_name || resource_params_by_params_key
    end
  end

  def resource_params_by_name
    @params[extract_key(name)]
  end

  def resource_params_by_params_key
    @params[@options[:params_key]] if @options.key?(:params_key)
  end

  def strong_parameters?
    ActionController.const_defined?('Parameters') && ActionController.const_get('Parameters').is_a?(Class)
  end
end
