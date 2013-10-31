require 'apirizer/controller_resource'

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
        # NOTE: drops support of InheritedResource
        Apirizer::ControllerResource
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        rescue_from 'ActiveRecord::RecordInvalid',  :with => :render_invalidation_error
        rescue_from 'ActiveRecord::RecordNotFound', :with => :render_not_found_error
        rescue_from(
          'ActiveModel::ForbiddenAttributesError',
          'ActiveRecord::RecordNotDestroyed',
          'CanCan::AccessDenied',
          :with => :render_violation_error
        )
      end
    end

    def index
      render_json collection: @_apirizer_resource.collection_instance
    end

    def show
      render_json record: @_apirizer_resource.resource_instance
    end

    def new
      render_json record: @_apirizer_resource.resource_instance
    end

    def edit
      render_json record: @_apirizer_resource.resource_instance
    end

    def create
      resource = @_apirizer_resource.resource_instance
      if resource.save!
        render_json record: resource, status: :created, location: created_resource_location(resource)
      end
    end

    def update
      resource = @_apirizer_resource.resource_instance
      if resource.update!(@_apirizer_resource.resource_params)
        head :no_content
      end
    end

    def destroy
      if @_apirizer_resource.resource_instance.destroy!
        head :no_content
      end
    end

  private

    def created_resource_location(resource)
      resource
    end

    def resource_decorator_class
      "#{@_apirizer_resource.namespaced_name.to_s.camelize}Decorator".constantize
    end

    def render_invalidation_error(ex)
      Rails.logger.warn(ex.inspect)
      render :json => ex.record.errors, :status => :unprocessable_entity
    end

    def render_not_found_error(ex)
      Rails.logger.warn(ex.inspect)
      head :not_found
    end

    def render_violation_error(ex)
      Rails.logger.warn(ex.inspect)
      head :method_not_allowed
    end
  end
end
