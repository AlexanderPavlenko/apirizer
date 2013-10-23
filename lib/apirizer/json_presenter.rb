require 'jbuilder'

module Apirizer
  module JsonPresenter

    # Class context

    def render_json(impl, data, action_name, fieldset_prefix=nil, fieldset=nil)
      send :"render_json_#{impl}", data, build_fieldset(action_name, fieldset_prefix, fieldset)
    end

    def render_json_record(data, fieldset)
      Jbuilder.encode do |json|
        json.set! json_root_key do
          new(data).send :"#{fieldset}_fieldset", json
        end
      end
    end

    def render_json_collection(data, fieldset)
      Jbuilder.encode do |json|
        json.set! json_root_key.pluralize do
          json.array! data do |item|
            new(item).send :"#{fieldset}_fieldset", json
          end
        end
        render_paginator(data, json)
      end
    end

    def render_paginator(data, json)
      if data.respond_to? :current_page
        json.total_pages  data.num_pages
        json.current_page data.current_page
      end
    end

    def render_json_custom(data, fieldset)
      Jbuilder.encode do |json|
        new(data).send :"#{fieldset}_fieldset", json
      end
    end

    def build_fieldset(action_name, fieldset_prefix, fieldset)
      fieldset ||= default_fieldset(action_name)
      [fieldset_prefix, fieldset].reject(&:blank?).join('_')
    end

    def json_root_key
      name.split('::').last.gsub(/Decorator\Z/, '').camelize(:lower)
    end

    def default_fieldset(action_name)
      case action_name
        when 'new', 'edit'
          action_name
        else
          'default'
      end
    end
  end
end
