class Apirizer::ControllerResource < CanCan::ControllerResource

  def initialize(controller, *args)
    super
    controller.instance_variable_set :@_apirizer_resource, self
  end

  # free the parrots!
  public *%w{
    collection_instance
    instance_name
    name
    name_from_controller
    namespace
    namespaced_name
    resource_instance
  }

  def resource_params
    if strong_parameters? && @controller.respond_to?(:permitted_params)
      # your custom declarations, just remove them!
      @controller.permitted_params
    else
      # maybe you're using 'resource' or even 'pony' key, not 'api_v1_resource'
      if @options.key?(:params_key)
        resource_params_by_params_key
      else
        resource_params_by_name || super
      end
    end
  end

  def resource_params_by_name
    @params[extract_key(name)]
  end

  def resource_params_by_params_key
    @params[@options[:params_key]]
  end

protected

  def build_resource
    # https://github.com/inossidabile/protector/issues/31
    resource = resource_base.new_with_protector(resource_params || {})
    assign_attributes(resource)
  end

  def resource_base
    base = super
    base.restrict!(@controller.current_user) if base.respond_to?(:restrict!)
    base
  end

  def strong_parameters?
    ActionController.const_defined?('Parameters') && ActionController.const_get('Parameters').is_a?(Class)
  end
end
