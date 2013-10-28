module Apirizer

  module Controller

    private

    def render_json(options)
      key = [:record, :collection, :custom].find{|k| options.key?(k) }
      data = options.delete(key)
      options[:json] = resource_decorator_class.render_json(key, data, action_name, fieldset_prefix, requested_fieldset)
      render options
    end

    def fieldset_prefix
      nil
    end

    def requested_fieldset
      params[:fs]
    end
  end


  module CanCanController
    include Controller

    module ClassMethods
      def cancan_resource_class
        klass = super
        Class.new(klass) do
          def initialize(controller, *args)
            super
            controller.instance_variable_set :@__cancan_resource, self
          end
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        rescue_from 'ActiveRecord::RecordInvalid', :with => :render_invalidation_error
        rescue_from(
          'ActiveRecord::RecordNotDestroyed',
          'ActiveModel::ForbiddenAttributesError',
          'CanCan::AccessDenied',
          :with => :render_violation_error
        )
      end
    end

    def index
      render_json collection: @__cancan_resource.send(:collection_instance)
    end

    def show
      render_json record: @__cancan_resource.send(:resource_instance)
    end

    def new
      render_json record: @__cancan_resource.send(:resource_instance)
    end

    def edit
      render_json record: @__cancan_resource.send(:resource_instance)
    end

    def create
      resource = @__cancan_resource.send(:resource_instance)
      if resource.save!
        render_json record: resource, status: :created, location: resource
      end
    end

    def update
      resource = @__cancan_resource.send(:resource_instance)
      if resource.update!(@__cancan_resource.send(:resource_params))
        head :no_content
      end
    end

    def destroy
      if @__cancan_resource.send(:resource_instance).destroy!
        head :no_content
      end
    end

    private

    def resource_decorator_class
      "#{@__cancan_resource.send(:namespaced_name).to_s.camelize}Decorator".constantize
    end

    def render_invalidation_error(exception)
      render :json => exception.record.errors, :status => :unprocessable_entity
    end

    def render_violation_error(_)
      head :method_not_allowed
    end
  end
end