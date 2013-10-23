require 'draper'
require 'apirizer/json_presenter'

module Apirizer
  class Decorator < Draper::Decorator
    extend JsonPresenter

    def new_fieldset(json)
    end

    def edit_fieldset(json)
    end

    def default_fieldset(json)
    end
  end
end
